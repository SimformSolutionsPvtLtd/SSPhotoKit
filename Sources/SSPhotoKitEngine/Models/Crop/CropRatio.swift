//
//  CropRatio.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreGraphics

public enum CropRatio: CaseIterable, Identifiable {
    
    case square, _1x2, _2x3, _3x4, golden
    
    public var id: String {
        ratio.name
    }
    
    public var ratio: Ratio {
        switch self {
        case .square:
            Ratio(name: "Square", height: 1, width: 1)
        case ._1x2:
            Ratio(height: 1, width: 2)
        case ._2x3:
            Ratio(height: 2, width: 3)
        case ._3x4:
            Ratio(height: 3, width: 4)
        case .golden:
            Ratio(height: 9, width: 16)
        }
    }
}

extension CropRatio {
    public struct Ratio : Hashable, CustomStringConvertible {
        
        // MARK: - Vars & Lets
        public let name: String
        public let height: UInt
        public let width: UInt
        
        public var description: String { name }
        
        public var value: CGFloat { CGFloat(height) / CGFloat(width) }
        
        // MARK: - Initializer
        public init(name: String, height: UInt, width: UInt) {
            self.name = name
            self.height = height
            self.width = width
        }
        
        public init(height: UInt, width: UInt) {
            self.init(name: "\(height):\(width)", height: height, width: width)
        }
        
        public func inverted() -> Ratio {
            Ratio(height: width, width: height)
        }
    }
}
