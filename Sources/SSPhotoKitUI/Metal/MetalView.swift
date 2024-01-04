//
//  MetalView.swift
//  SSPhotoKitPlayground
//
//  Created by Krunal Patel on 08/12/23.
//

import MetalKit
import SwiftUI
import Combine

struct MetalView: PlatformAgnosticViewRepresentable {
    
    @Binding var image: CIImage
    
    func makePlatformView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.device = context.coordinator.device
        mtkView.framebufferOnly = false
        mtkView.enableSetNeedsDisplay = true
        mtkView.isPaused = true
        return mtkView
    }
    
    func updatePlatformView(_ uiView: MTKView, context: Context) {
        context.coordinator.updateImage(image)
        uiView.draw()
    }
    
    func makeCoordinator() -> Renderer {
        Renderer(image: image)
    }
}

final class Renderer: NSObject, MTKViewDelegate, ObservableObject {
    
    // MARK: - Vars & Lets
    let device: MTLDevice
    private var image: CIImage
    private let commandQueue: MTLCommandQueue
    private let context: CIContext
    
    // MARK: - Methods
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        view.setNeedsDisplay()
    }
    
    func draw(in view: MTKView) {
        
        let image = getScaledImage(for: view.drawableSize)
        
        guard let drawable = view.currentDrawable,
              let commandBuffer = commandQueue.makeCommandBuffer() else {
            print("Failed to draw")
            return
        }
        
        let destination = CIRenderDestination(
            width: drawable.texture.width,
            height: drawable.texture.height,
            pixelFormat: view.colorPixelFormat,
            commandBuffer: commandBuffer) { () -> MTLTexture in
                drawable.texture
            }
        
        do {
            try context.startTask(toRender: image, to: destination)
        } catch {
            print(error.localizedDescription)
            return
        }
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    // MARK: - Initializer
    init(image: CIImage, device: MTLDevice? = nil) {
        
        guard let device = device ?? MTLCreateSystemDefaultDevice(),
        let commandQueue = device.makeCommandQueue() else {
            fatalError("Failed to create metal renderer.")
        }

        self.device = device
        self.commandQueue = commandQueue
        self.context = CIContext(mtlDevice: device, options: [.cacheIntermediates: false])

        self.image = image
        super.init()
    }
}

extension Renderer {
        
    func updateImage(_ image: CIImage) {
        self.image = image
    }
    
    private func getScaledImage(for size: CGSize) -> CIImage {
        return image.resizing(size)
    }
    
    private func makeRenderDestination(for view: MTKView, drawable: CAMetalDrawable, commandBuffer: MTLCommandBuffer) -> CIRenderDestination {
        CIRenderDestination(
            width: Int(view.drawableSize.width),
            height: Int(view.drawableSize.height),
            pixelFormat: view.colorPixelFormat,
            commandBuffer: commandBuffer) { () -> MTLTexture in
                drawable.texture
            }
    }
}
