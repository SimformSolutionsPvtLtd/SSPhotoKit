//
//  NaturalFilter.swift
//
//
//  Created by Krunal Patel on 04/01/24.
//

import CoreImage.CIFilterBuiltins

public struct NaturalFilter : Filter {
    
    public var name: String = "Original"
    
    public func apply(to image: CIImage) -> CIImage {
        return image
    }
    
    // MARK: - Initializer
    public init() { }
}

extension Filter where Self == NaturalFilter {
    
    public static var original: Self { .init() }
}
