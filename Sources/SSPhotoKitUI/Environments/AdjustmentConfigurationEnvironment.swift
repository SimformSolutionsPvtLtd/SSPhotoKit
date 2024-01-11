//
//  AdjustmentConfiguration.swift
//  SSPhotoKitUI
//
//  Created by Krunal Patel on 15/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct AdjustmentConfigurationKey: EnvironmentKey {
    
    static let defaultValue: AdjustmentConfiguration = .init()
}


extension EnvironmentValues {
    
    var adjustmentConfiguration: AdjustmentConfiguration {
        get { self[AdjustmentConfigurationKey.self] }
        set { self[AdjustmentConfigurationKey.self] = newValue }
    }
}
