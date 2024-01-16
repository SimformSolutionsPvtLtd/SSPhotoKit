//
//  Renderer.swift
//  SSPhotoKitRenderer
//
//  Created by Krunal Patel on 16/01/24.
//

import MetalKit

final class Renderer: NSObject, MTKViewDelegate, ObservableObject {
    
    // MARK: - Vars & Lets
    let device: MTLDevice
    private var image: CIImage
    private let commandQueue: MTLCommandQueue
    private let context: CIContext
    private lazy var colorSpace: CGColorSpace = {
        image.colorSpace ?? CGColorSpaceCreateDeviceRGB()
    }()
    
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
        
        let offset = CGPoint(x: (view.drawableSize.width - image.extent.size.width) / 2,
                             y: (view.drawableSize.height - image.extent.size.height) / 2)
        
        do {
            // Need to optimize for CPU usage.
            try context.startTask(toRender: image,
                                  from: image.extent,
                                  to: makeRenderDestination(for: view, drawable: drawable, commandBuffer: commandBuffer),
                                  at: offset)
            //            context.render(image,
            //                           to: drawable.texture,
            //                           commandBuffer: commandBuffer,
            //                           bounds: image.extent,
            //                           colorSpace: colorSpace)
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

// MARK: - Methods
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
