//
//  FilterAttribute.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//

public struct FilterAttribute : Hashable {
    
    // MARK: - Vars & Lets
    public var value: Float
    public let defaultValue: Float
    public let range: ClosedRange<Float>
    
    // MARK: - Initializer
    public init(_ value: Float, range: ClosedRange<Float>) {
        self.value = value
        self.defaultValue = value
        self.range = range
    }
}
