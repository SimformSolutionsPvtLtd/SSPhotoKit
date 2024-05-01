//
//  AdjustmentConfigurationEnvironment.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 15/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

// MARK: - EnvironmentKey
struct AdjustmentConfigurationKey: EnvironmentKey {
    
    static let defaultValue: AdjustmentConfiguration = .init()
}

// MARK: - EnvironmentValue
extension EnvironmentValues {
    
    var adjustmentConfiguration: AdjustmentConfiguration {
        get { self[AdjustmentConfigurationKey.self] }
        set { self[AdjustmentConfigurationKey.self] = newValue }
    }
}
