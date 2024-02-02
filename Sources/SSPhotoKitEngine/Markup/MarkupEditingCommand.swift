//
//  MarkupEditingCommand.swift
//  
//
//  Created by Krunal Patel on 05/01/24.
//

import CoreImage
import SwiftUI

public struct MarkupEditingCommand<Content> : EditingCommand where Content : View {
    
    public var layers: [MarkupLayer]
    public var scale: CGSize
    @ViewBuilder public var renderer: ([MarkupLayer]) -> Content
    
    private let filter = CIFilter.sourceOverCompositing()
        
    public func apply(to image: CIImage) async -> CIImage {

        filter.backgroundImage = image
        filter.inputImage = await getLayerImage(size: image.size)
        
        guard let outputImage = filter.outputImage else {
            EngineLogger.error("Can't apply \(String(describing: self))")
            return image
        }
        
        return outputImage.cropped(to: image.extent)
    }
    
    @MainActor
    private func getLayerImage(size: CGSize) -> CIImage {
    
        let viewRenderer = ImageRenderer(content: renderer(getScaledLayers()).frame(width: size.width, height: size.height))
        
        let image = CIImage(cgImage: viewRenderer.cgImage!)
        
        return CIImage(cgImage: viewRenderer.cgImage!)
    }
    
    private func getScaledLayers() -> [MarkupLayer] {
        var copy = layers
        for i in copy.indices {
            copy[i].scale = scale
        }
        return copy
    }
    
    public func hash(into hasher: inout Hasher) {
        layers.hash(into: &hasher)
        filter.hash(into: &hasher)
    }
    
    public static func == (lhs: MarkupEditingCommand, rhs: MarkupEditingCommand) -> Bool {
        lhs.layers == rhs.layers && lhs.filter == rhs.filter
    }
    
    // MARK: - Initializer
    public init(layers: [MarkupLayer] = [], scale: CGSize = CGSize(width: 1, height: 1), @ViewBuilder renderer: @escaping ([MarkupLayer]) -> Content) {
        self.layers = layers
        self.scale = scale
        self.renderer = renderer
    }
}
