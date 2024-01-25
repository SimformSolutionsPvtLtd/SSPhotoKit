//
//  CGPoint+Extension.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreGraphics

// MARK: - Hashable
extension CGPoint : Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

extension CGRect: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(origin.x)
        hasher.combine(origin.y)
        hasher.combine(size.width)
        hasher.combine(size.height)
    }
}

