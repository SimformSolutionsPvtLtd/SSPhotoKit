//
//  GaussianBlurFilter.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreImage.CIFilterBuiltins

public struct GaussianBlurFilter : Filter {
    
    public var name: String = "Gaussian Blur"
    private let filter = CIFilter.gaussianBlur()
    
    public var radius: FilterAttribute
    
    public func apply(to image: CIImage) -> CIImage {
        filter.inputImage = image.clamped(to: image.extent)
        filter.radius = radius.value
        
        guard let outputImage = filter.outputImage else {
            EngineLogger.error("Can't apply \(String(describing: self))")
            return image
        }
        
        return outputImage.cropped(to: image.extent)
    }
    
    
    public static func == (lhs: GaussianBlurFilter, rhs: GaussianBlurFilter) -> Bool {
        lhs.radius == rhs.radius && lhs.filter == rhs.filter
    }
    
    public func hash(into hasher: inout Hasher) {
        radius.hash(into: &hasher)
        filter.hash(into: &hasher)
    }
    
    // MARK: - Initializer
    public init(radius: Float = 0) {
        self.radius = filter.makeAttribute(for: kCIInputRadiusKey)
        self.radius.value = 0
    }
}

extension Filter where Self == GaussianBlurFilter {
    
    public static var gaussianBlur: Self { .init() }
}
