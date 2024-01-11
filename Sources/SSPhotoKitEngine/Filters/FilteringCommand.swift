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
    
    public let base: AnyHashable
    public var name: String
    public var scale: CGSize {
        get { _getScale() }
        set { _setScale(newValue) }
    }
    public var intensity: CGFloat {
        get { _getIntensity() }
        set { _setIntensity(newValue) }
    }
    
    private let _getScale: () -> CGSize
    private let _setScale: (CGSize) -> Void
    private let _getIntensity: () -> CGFloat
    private let _setIntensity: (CGFloat) -> Void
    private let _apply: (CIImage) async -> CIImage
    
    init<F: Filter>(_ filter: F) {
        var copy = filter
        base = copy
        name = copy.name
        _getScale = { copy.scale }
        _setScale = { value in copy.scale = value }
        _getIntensity = { copy.intensity }
        _setIntensity = { value in copy.intensity = value }
        _apply = { image in await copy.apply(to: image) }
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
        (self as? AnyFilter) ?? AnyFilter(self)
    }
}
