//
//  AdjustmentConfiguration.swift
//
//
//  Created by Krunal Patel on 15/01/24.
//

public struct AdjustmentConfiguration {
    
    // MARK: - Vars & Lets
    public var allowedAdjustments: AllowedAdjustmentOptions
    
    // MARK: - Initializer
    public init(allowedAdjustments: AllowedAdjustmentOptions = .all) {
        self.allowedAdjustments = allowedAdjustments
    }
}

// MARK: - Options
extension AdjustmentConfiguration {
    
    public struct AllowedAdjustmentOptions : OptionSet {
        
        public var rawValue: UInt32
        
        // Light
        public static let brightness = AllowedAdjustmentOptions(rawValue: 1 << 0)
        public static let contrast = AllowedAdjustmentOptions(rawValue: 1 << 1)
        public static let saturation = AllowedAdjustmentOptions(rawValue: 1 << 2)
        public static let hue = AllowedAdjustmentOptions(rawValue: 1 << 3)
        
        public static let light: AllowedAdjustmentOptions = [.brightness, .contrast, .saturation, .hue]
        
        // Blur
        public static let blur = AllowedAdjustmentOptions(rawValue: 1 << 4)
        
        // All
        public static let all: AllowedAdjustmentOptions = [.light, .blur]
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
    }
}
