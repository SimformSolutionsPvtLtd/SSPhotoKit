//
//  CropRatio.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//

public struct CropRatio : Hashable, CustomStringConvertible {
    
    // MARK: - Vars & Lets
    public let name: String
    public let height: UInt
    public let width: UInt
    
    public var description: String { name }
    
    // MARK: - Initializer
    public init(name: String, height: UInt, width: UInt) {
        self.name = name
        self.height = height
        self.width = width
    }
    
    public init(height: UInt, width: UInt) {
        self.init(name: "\(height):\(width)", height: height, width: width)
    }
    
    public func inverted() -> CropRatio {
        CropRatio(height: width, width: height)
    }
}
