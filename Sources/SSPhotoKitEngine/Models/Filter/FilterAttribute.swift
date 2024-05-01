//
//  FilterAttribute.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//

@propertyWrapper
public struct FilterAttribute<Value>: Equatable where Value : Comparable {

    // MARK: - Vars & Lets
    public var wrappedValue: Value {
        didSet {
            wrappedValue = wrappedValue.clamped(to: projectedValue)
        }
    }
    
    public let projectedValue: ClosedRange<Value>
    
    // MARK: - Initializer
    public init(wrappedValue: Value, range: ClosedRange<Value>) {
        self.wrappedValue = wrappedValue
        self.projectedValue = range
    }
}
