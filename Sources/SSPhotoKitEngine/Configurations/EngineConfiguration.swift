//
//  EngineConfigurations.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 11/01/24.
//

import CoreGraphics

/// Configuration for Engine.
public struct EngineConfiguration {
    
    // MARK: - Vars & Lets
    /// Image preview size. Prefer screen sizer for this.
    public var previewSize: CGSize
    
    // MARK: - Initializer
    /// Initialize Configuration object for Engine.
    ///
    /// - Parameter previewSize: Preview size for image.
    public init(previewSize: CGSize) {
        self.previewSize = previewSize
    }
}
