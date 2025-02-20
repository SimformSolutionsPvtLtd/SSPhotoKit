//
//  FilterConfigurationEnvironment.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 16/01/24.
//

import SwiftUI

// MARK: - EnvironmentKey
struct FilterConfigurationKey: EnvironmentKey {
    
    static let defaultValue: FilterConfiguration = .init()
}

// MARK: - EnvironmentValue
extension EnvironmentValues {
    
    var filterConfiguration: FilterConfiguration {
        get { self[FilterConfigurationKey.self] }
        set { self[FilterConfigurationKey.self] = newValue }
    }
}
