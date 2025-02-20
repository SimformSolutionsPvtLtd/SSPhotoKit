//
//  CGPoint+Extension.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreGraphics

// MARK: - Hashable

// MARK: - CGPoint
extension CGPoint: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

// MARK: - CGRect
extension CGRect: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(origin.x)
        hasher.combine(origin.y)
        hasher.combine(size.width)
        hasher.combine(size.height)
    }
}

// MARK: - CGSize
extension CGSize: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}
