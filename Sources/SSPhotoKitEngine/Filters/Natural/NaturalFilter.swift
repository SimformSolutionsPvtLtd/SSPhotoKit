//
//  NaturalFilter.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 04/01/24.
//

import CoreImage.CIFilterBuiltins

public struct NaturalFilter: Filter {
    
    // MARK: - Vars & Lets
    public var name: String = "Original"
    
    // MARK: - Methods
    public func apply(to image: CIImage) -> CIImage {
        return image
    }
    
    // MARK: - Initializer
    public init() { }
}

// MARK: - Extension
extension Filter where Self == NaturalFilter {
    
    public static var original: Self { .init() }
}
