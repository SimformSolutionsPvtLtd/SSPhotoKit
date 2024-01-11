//
//  HueFilter.swift
//
//
//  Created by Krunal Patel on 03/01/24.
//

import CoreImage.CIFilterBuiltins

public struct HueFilter : Filter {
    
    public var name: String = "Hue"
    let filter = CIFilter.hueAdjust()
    
    @FilterAttribute public var hue: Float
    
    public func apply(to image: CIImage) -> CIImage {
        filter.inputImage = image.clamped(to: image.extent)
        
        filter.angle = hue
        
        guard let outputImage = filter.outputImage else {
            EngineLogger.error("Can't apply \(String(describing: self))")
            return image
        }
        
        return outputImage.cropped(to: image.extent)
    }
    
    public static func == (lhs: HueFilter, rhs: HueFilter) -> Bool {
        lhs.filter == rhs.filter &&
        lhs.hue == rhs.hue
    }
    
    public func hash(into hasher: inout Hasher) {
        filter.hash(into: &hasher)
    }
    
    // MARK: - Initializer
    public init() {
        self._hue = filter.makeAttribute(for: kCIInputAngleKey)
    }
}

extension Filter where Self == HueFilter {
    
    public static var hue: Self { .init() }
}
