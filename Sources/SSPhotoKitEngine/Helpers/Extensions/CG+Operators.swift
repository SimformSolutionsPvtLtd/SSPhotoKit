//
//  File.swift
//  
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreGraphics

extension CGSize {
    
    public static func /(lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width / rhs.width,
               height: lhs.height / rhs.height)
    }
    
    public static func *(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width * rhs.width,
                      height: lhs.height * rhs.height)
    }
    
    public static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width,
               height: lhs.height + rhs.height)
    }

    public static func -(lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width - rhs.width,
               height: lhs.height - rhs.height)
    }
    
    public static func *=(lhs: inout CGSize, rhs: CGSize) {
        lhs.width *= rhs.width
        lhs.height *= rhs.height
    }
}

extension CGPoint {
    
    public static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x,
                       y: lhs.y + rhs.y)
    }
    
    public static func +=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
}
