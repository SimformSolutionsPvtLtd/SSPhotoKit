//
//  GeometryHelper.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 12/01/24.
//

import Foundation

// MARK: - Angle & Radian
extension FloatingPoint {
    
    public func toRadian() -> Self {
        self * (.pi / 180)
    }
    
    public func toAngle() -> Self {
        self * (180 / .pi)
    }
}

extension BinaryInteger {
    
    public func toRadian<T>() -> T where T: FloatingPoint {
        T(self) * (.pi / 180)
    }
    
    public func toAngle<T>() -> T where T: FloatingPoint {
        T(self) * (180 / .pi)
    }
}

// MARK: - GCD
public func gcd<T>(_ num1: T, _ num2: T) -> T where T: BinaryFloatingPoint {
    let remainder = abs(num1).truncatingRemainder(dividingBy: abs(num2))
    
    if remainder != 0 {
        return gcd(abs(num2), remainder)
    } else {
        return abs(num2)
    }
}

public func gcd<T>(_ num1: T, _ num2: T) -> T where T: SignedInteger {
    let remainder = abs(num1) % abs(num2)
    
    if remainder != 0 {
        return gcd(abs(num2), remainder)
    } else {
        return abs(num2)
    }
}

public func gcd<T>(_ num1: T, _ num2: T) -> T where T: BinaryInteger {
    let remainder = num1 % num2
    
    if remainder != 0 {
        return gcd(num2, remainder)
    } else {
        return num2
    }
}

// MARK: - Absolute
public func abs(_ size: CGSize) -> CGSize {
    CGSize(width: abs(size.width), height: abs(size.height))
}
