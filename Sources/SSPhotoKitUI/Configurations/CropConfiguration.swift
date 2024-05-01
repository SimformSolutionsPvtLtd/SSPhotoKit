//
//  CropConfiguration.swift
//  
//
//  Created by Krunal Patel on 12/01/24.
//

import SwiftUI
import SSPhotoKitEngine

public struct CropConfiguration {
    
    // MARK: - Vars & Lets
    public var customRatios: [AspectRatio]
    
    public var ratioOptions: RatioOptions
    
    public var labelType: LabelType
    
    // MARK: - Methods
    public var cropRatios: [AspectRatio] {
        switch ratioOptions {
        case .custom:
            customRatios
        case .default:
            AspectRatio.defaults
        case .all:
            AspectRatio.defaults + customRatios
        default:
            []
        }
    }
        
    // MARK: - Initializer
    public init(customRatios: [AspectRatio] = [],
                ratioOptions: RatioOptions = .all,
                labelType: LabelType = .text) {
        self.customRatios = customRatios
        self.ratioOptions = ratioOptions
        self.labelType = labelType
    }
}

// MARK: - Enums
extension CropConfiguration {
    
    public enum LabelType {
        case icon, text, iconWithText
    }
}

// MARK: - Options
extension CropConfiguration {
    
    public struct RatioOptions: OptionSet {
        
        public var rawValue: UInt32
        
        public static let original = RatioOptions(rawValue: 1 << 0)
        
        public static let `default` = RatioOptions(rawValue: 1 << 1)
        
        public static let custom = RatioOptions(rawValue: 1 << 2)
        
        public static let all: RatioOptions = [.original, .default, .custom]
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
    }
}
