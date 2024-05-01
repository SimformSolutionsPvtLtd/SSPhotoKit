//
//  EngineConfigurations.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 11/01/24.
//

import CoreGraphics

public struct EngineConfiguration {
    
    // MARK: - Vars & Lets
    public var previewSize: CGSize
    
    // MARK: - Initializer
    public init(previewSize: CGSize) {
        self.previewSize = previewSize
    }
}
