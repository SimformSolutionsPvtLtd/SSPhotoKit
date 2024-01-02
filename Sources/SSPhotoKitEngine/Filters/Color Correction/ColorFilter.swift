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
    
    public var contrast: FilterAttribute
    public var brightness: FilterAttribute
    public var saturation: FilterAttribute
    
    public func apply(to image: CIImage) -> CIImage {
        filter.inputImage = image.clamped(to: image.extent)
        filter.brightness = brightness.value
        filter.contrast = contrast.value
        filter.saturation = saturation.value
        
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
        self.contrast = filter.makeAttribute(for: kCIInputContrastKey)
        self.brightness = filter.makeAttribute(for: kCIInputBrightnessKey)
        self.saturation = filter.makeAttribute(for: kCIInputSaturationKey)
    }
}

extension Filter where Self == ColorFilter {
    
    public static var color: Self { .init() }
}
