//
//  Number+Extension.swift
//
//
//  Created by Krunal Patel on 02/05/24.
//

import Foundation

// MARK: - Round
extension Double {
    
    /// Round receiver double to given places in string format.
    ///
    /// - Parameter places: Number of precision
    /// - Returns: New rounded number
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    /// Round receiver double to given places.
    ///
    /// - Parameter places: Number of precision
    /// - Returns: New rounded number in string format
    func roundedString(to places: Int) -> String {
        let value = rounded(to: places)
        return String(format: "%.\(places)f", value)
    }
}

extension Float {
    
    /// Round receiver flot to given places.
    ///
    /// - Parameter places: Number of precision
    /// - Returns: New rounded number
    func rounded(to places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
    
    /// Round receiver flot to given places in string format.
    ///
    /// - Parameter places: Number of precision
    /// - Returns: New rounded number in string format
    func roundedString(to places: Int) -> String {
        let value = rounded(to: places)
        return String(format: "%.\(places)f", self)
    }
}
