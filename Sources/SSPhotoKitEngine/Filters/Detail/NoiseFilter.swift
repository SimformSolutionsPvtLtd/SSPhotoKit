//
//  NoiseFilter.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 08/01/24.
//

import CoreImage.CIFilterBuiltins

public struct NoiseFilter: Filter {
    
    // MARK: - Vars & Lets
    public var name: String = "Noise"
    let filter = CIFilter.noiseReduction()
    
    @FilterAttribute public var noiseLevel: Float
    @FilterAttribute public var sharpness: Float
    
    // MARK: - Methods
    public func apply(to image: CIImage) -> CIImage {
        filter.inputImage = image.clamped(to: image.extent)
        
        filter.noiseLevel = noiseLevel
        filter.sharpness = sharpness
        
        guard let outputImage = filter.outputImage else {
            EngineLogger.error("Can't apply \(String(describing: self))")
            return image
        }
        
        return outputImage.cropped(to: image.extent)
    }
    
    public static func == (lhs: NoiseFilter, rhs: NoiseFilter) -> Bool {
        lhs.filter == rhs.filter &&
        lhs.noiseLevel == rhs.noiseLevel &&
        lhs.sharpness == rhs.sharpness
    }
    
    public func hash(into hasher: inout Hasher) {
        filter.hash(into: &hasher)
        noiseLevel.hash(into: &hasher)
        sharpness.hash(into: &hasher)
    }
    
    // MARK: - Initializer
    public init() {
        self._noiseLevel = filter.makeAttribute(for: kCIInputNoiseLevelKey)
        self._sharpness = filter.makeAttribute(for: kCIInputSharpnessKey)
    }
}

// MARK: - Extension
extension Filter where Self == NoiseFilter {
    
    public static var noise: Self { .init() }
}

// MARK: - Constant
public let kCIInputNoiseLevelKey: String = "inputNoiseLevel"
