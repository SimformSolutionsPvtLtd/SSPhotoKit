//
//  GeometryHelper.swift
//
//
//  Created by Krunal Patel on 12/01/24.
//

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
    
    public func toRadian<T>() -> T where T : FloatingPoint {
        T(self) * (.pi / 180)
    }
    
    public func toAngle<T>() -> T where T : FloatingPoint {
        T(self) * (180 / .pi)
    }
}

// MARK: - GCD
public func gcd<T>(_ a: T, _ b: T) -> T where T : BinaryFloatingPoint {
    let remainder = abs(a).truncatingRemainder(dividingBy: abs(b))
    
    if remainder != 0 {
        return gcd(abs(b), remainder)
    } else {
        return abs(b)
    }
}

public func gcd<T>(_ a: T, _ b: T) -> T where T : SignedInteger {
    let remainder = abs(a) % abs(b)
    
    if remainder != 0 {
        return gcd(abs(b), remainder)
    } else {
        return abs(b)
    }
}

public func gcd<T>(_ a: T, _ b: T) -> T where T : BinaryInteger {
    let remainder = a % b
    
    if remainder != 0 {
        return gcd(b, remainder)
    } else {
        return b
    }
}


