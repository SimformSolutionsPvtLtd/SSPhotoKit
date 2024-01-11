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
    
    public static func /=(lhs: inout CGSize, rhs: CGSize) {
        lhs.width /= rhs.width
        lhs.height /= rhs.height
    }
    
    public static func *=(lhs: inout CGSize, rhs: CGSize) {
        lhs.width *= rhs.width
        lhs.height *= rhs.height
    }
    
    public static func +=(lhs: inout CGSize, rhs: CGSize) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }
    
    public static prefix func -(value: CGSize) -> CGSize {
        CGSize(width: -value.width, height: -value.height)
    }
    
    public static let one: CGSize = CGSize(width: 1, height: 1)
    
    public func toCGPoint() -> CGPoint {
        CGPoint(x: width, y: height)
    }
}

extension CGPoint {
    
    public static func /=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x /= rhs.x
        lhs.y /= rhs.y
    }
    
    public static func *=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x *= rhs.x
        lhs.y *= rhs.y
    }
    
    public static func -=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }
    
    public static func *(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x * rhs.x,
                      y: lhs.y * rhs.y)
    }
    
    public static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x,
                       y: lhs.y + rhs.y)
    }
    
    public static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x,
                       y: lhs.y - rhs.y)
    }
    
    public static func +=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
    
    public func toCGSize() -> CGSize {
        CGSize(width: x, height: y)
    }
}

extension CGRect {
    
    public static func +=(lhs: inout CGRect, rhs: CGRect) {
        lhs.size = rhs.size
        lhs.origin = rhs.origin
    }
}

public func max(_ first: CGSize, _ second: CGSize) -> CGSize {
    first.width > second.width ? first : second
}
