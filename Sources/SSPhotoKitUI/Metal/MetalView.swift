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
    
    // MARK: - Vars & Lets
    @Binding var image: CIImage
    
    // MARK: - Methods
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
