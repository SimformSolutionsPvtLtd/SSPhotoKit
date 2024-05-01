//
//  CropRatio.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreGraphics

public struct AspectRatio: Identifiable, Hashable, CustomStringConvertible {
    
    // MARK: - Vars & Lets
    public var id: Int { hashValue }
    
    public let name: String
    public let height: UInt
    public let width: UInt
    
    public var description: String { name }
    
    public var value: CGFloat { CGFloat(height) / CGFloat(width) }
    
    // MARK: - Initializer
    public init(name: String? = nil, height: UInt, width: UInt) {
        let gcd = gcd(height, width)
        let newHeight = height / gcd
        let newWidth = width / gcd
        
        self.name = name ?? "\(newHeight):\(newWidth)"
        self.height = newHeight
        self.width = newWidth
    }
    
    // MARK: - Methods
    public func inverted() -> AspectRatio {
        AspectRatio(height: width, width: height)
    }
}

// MARK: - Default Ratios
extension AspectRatio {
    
    public static let defaults = [
        AspectRatio(name: "Square", height: 1, width: 1),
        AspectRatio(height: 1, width: 2),
        AspectRatio(height: 2, width: 3),
        AspectRatio(height: 3, width: 4),
        AspectRatio(height: 9, width: 16)
    ]
}
