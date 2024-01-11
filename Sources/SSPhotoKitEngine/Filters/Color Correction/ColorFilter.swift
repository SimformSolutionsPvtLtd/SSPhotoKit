//
//  ColorFilter.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreImage.CIFilterBuiltins

public struct ColorFilter : Filter {
    
    public var name: String = "Color Correction"
    let filter = CIFilter.colorControls()
    
    @FilterAttribute public var contrast: Float
    @FilterAttribute public var brightness: Float
    @FilterAttribute public var saturation: Float
    
    public func apply(to image: CIImage) -> CIImage {
        filter.inputImage = image.clamped(to: image.extent)
        filter.brightness = brightness
        filter.contrast = contrast
        filter.saturation = saturation
        
        guard let outputImage = filter.outputImage else {
            EngineLogger.error("Can't apply \(String(describing: self))")
            return image
        }
        
        return outputImage.cropped(to: image.extent)
    }
    
    public static func == (lhs: ColorFilter, rhs: ColorFilter) -> Bool {
        lhs.brightness == rhs.brightness && lhs.contrast == rhs.contrast && lhs.saturation == rhs.saturation
    }
    
    public func hash(into hasher: inout Hasher) {
        filter.hash(into: &hasher)
    }
    
    // MARK: - Initializer
    public init() {
        self._contrast = filter.makeAttribute(for: kCIInputContrastKey)
        self._brightness = filter.makeAttribute(for: kCIInputBrightnessKey)
        self._saturation = filter.makeAttribute(for: kCIInputSaturationKey)
    }
}

extension Filter where Self == ColorFilter {
    
    public static var color: Self { .init() }
}
