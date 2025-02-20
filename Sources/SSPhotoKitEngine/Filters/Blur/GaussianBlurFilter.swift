//
//  GaussianBlurFilter.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreImage.CIFilterBuiltins

public struct GaussianBlurFilter: Filter {
    
    // MARK: - Vars & Lets
    public var name: String = "Gaussian Blur"
    public var scale: CGSize = .one
    private let filter = CIFilter.gaussianBlur()
    
    @FilterAttribute public var radius: Float
    
    // MARK: - Methods
    public func apply(to image: CIImage) -> CIImage {
        filter.inputImage = image.clamped(to: image.extent)
        filter.radius = radius * Float(scale.width)
        
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
    public init(radius: Float = 0, imageSize: CGSize? = nil) {
         if let imageSize {
            let minSize = min(imageSize.width, imageSize.height)
             self._radius = FilterAttribute(wrappedValue: 0, range: 0...(Float(minSize) / 20))
        } else {
            self._radius = filter.makeAttribute(for: kCIInputRadiusKey)
        }
        self.radius = 0
    }
}

// MARK: - Extension
extension Filter where Self == GaussianBlurFilter {
    
    public static var gaussianBlur: Self { .init() }
}
