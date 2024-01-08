//
//  SharpenFilter.swift
//
//
//  Created by Krunal Patel on 08/01/24.
//


import CoreImage.CIFilterBuiltins

public struct SharpenFilter : Filter {
    
    public var name: String = "Sharpen"
    let filter = CIFilter.unsharpMask()
    
    public var radius: FilterAttribute
    public var amount: FilterAttribute
    
    public func apply(to image: CIImage) -> CIImage {
        filter.inputImage = image.clamped(to: image.extent)
        
        filter.radius = radius.value
        filter.intensity = amount.value
        
        guard let outputImage = filter.outputImage else {
            EngineLogger.error("Can't apply \(String(describing: self))")
            return image
        }
        
        return outputImage.cropped(to: image.extent)
    }
    
    public static func == (lhs: SharpenFilter, rhs: SharpenFilter) -> Bool {
        lhs.filter == rhs.filter &&
        lhs.radius == rhs.radius &&
        lhs.amount == rhs.amount
    }
    
    public func hash(into hasher: inout Hasher) {
        filter.hash(into: &hasher)
        radius.hash(into: &hasher)
        amount.hash(into: &hasher)
    }
    
    // MARK: - Initializer
    public init() {
        self.radius = filter.makeAttribute(for: kCIInputRadiusKey)
        self.amount = filter.makeAttribute(for: kCIInputIntensityKey)
    }
}

extension Filter where Self == SharpenFilter {
    
    public static var sharpen: Self { .init() }
}
