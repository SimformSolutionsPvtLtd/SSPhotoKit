//
//  CropConfigurationEnvironment.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 12/01/24.
//

import SwiftUI

// MARK: - EnvironmentKey
struct CropConfigurationKey: EnvironmentKey {
    
    static let defaultValue: CropConfiguration = .init()
}

// MARK: - EnvironmentValue
extension EnvironmentValues {
    
    var cropConfiguration: CropConfiguration {
        get { self[CropConfigurationKey.self] }
        set { self[CropConfigurationKey.self] = newValue }
    }
}
