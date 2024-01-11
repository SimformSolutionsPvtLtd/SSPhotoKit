//
//  FilterConfiguration.swift
//  SSPhotoKitUI
//
//  Created by Krunal Patel on 16/01/24.
//

import SwiftUI

struct FilterConfigurationKey: EnvironmentKey {
    
    static let defaultValue: FilterConfiguration = .init()
}


extension EnvironmentValues {
    
    var filterConfiguration: FilterConfiguration {
        get { self[FilterConfigurationKey.self] }
        set { self[FilterConfigurationKey.self] = newValue }
    }
}
