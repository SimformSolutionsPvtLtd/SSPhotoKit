//
//  Comparable+Extension.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 02/01/24.
//

// MARK: - Comparable Extension
extension Comparable {
    
    // MARK: - Clamp
    /// Clamps the value to given range.
    ///
    /// - Parameter limits: The range containing upper and lower bound.
    /// - Returns: A new clamped value within given range.
    public func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
