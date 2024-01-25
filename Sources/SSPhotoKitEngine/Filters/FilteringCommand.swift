//
//  File.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreGraphics
import CoreImage.CIFilterBuiltins

/// A protocol that represent filter functionality. For using any filter on
/// your image the type must confirms this protocol.
public protocol Filter : EditingCommand {
    
    var name: String { get }
    var intensity: CGFloat { get set }
}

extension Filter {
    
    public var intensity: CGFloat {
        get {
            1.0
        }
        set {
            
        }
    }
    
    public func composit(source: CIImage, destination: CIImage) -> CIImage {
        let colorMatrix = CIFilter.colorMatrix()
        colorMatrix.setDefaults()
        colorMatrix.inputImage = source
        colorMatrix.aVector = CIVector(x: 0, y: 0, z: 0, w: intensity)
        
        let composit = CIFilter.sourceOverCompositing()
        composit.setDefaults()
        composit.inputImage = colorMatrix.outputImage
        composit.backgroundImage = destination
        
        if let output = composit.outputImage {
            return output.cropped(to: output.extent)
        } else {
            return source
        }
    }
}

// MARK: - AnyFilteringCommand
public struct AnyFilter : Filter {
    
    public var intensity: CGFloat
    public var name: String
    public let base: AnyHashable
    private let _apply: (CIImage) async -> CIImage
    
    init<F: Filter>(_ filter: F) {
        base = filter
        name = filter.name
        intensity = filter.intensity
        _apply = filter.apply
    }
    
    public func apply(to image: CIImage) async -> CIImage {
        await _apply(image)
    }
    
    public static func == (lhs: AnyFilter, rhs: AnyFilter) -> Bool {
        lhs.base == rhs.base
    }
    
    public func hash(into hasher: inout Hasher) {
        base.hash(into: &hasher)
    }
    
}

extension Filter {
    
    public func asAny() -> AnyFilter {
        AnyFilter(self)
    }
}
