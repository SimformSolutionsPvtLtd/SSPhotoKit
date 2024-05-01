//
//  CropConfiguration.swift
//  SSPhotoKitUI
//
//  Created by Krunal Patel on 12/01/24.
//

import SwiftUI

struct CropConfigurationKey: EnvironmentKey {
    
    static let defaultValue: CropConfiguration = .init()
}


extension EnvironmentValues {
    
    var cropConfiguration: CropConfiguration {
        get { self[CropConfigurationKey.self] }
        set { self[CropConfigurationKey.self] = newValue }
    }
}
