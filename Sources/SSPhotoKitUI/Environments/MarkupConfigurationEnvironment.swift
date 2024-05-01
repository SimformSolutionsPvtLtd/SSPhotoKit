//
//  MarkupConfiguration.swift
//  SSPhotoKitUI
//
//  Created by Krunal Patel on 15/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct MarkupConfigurationKey: EnvironmentKey {
    
    static let defaultValue: MarkupConfiguration = .init()
}


extension EnvironmentValues {
    
    var markupConfiguration: MarkupConfiguration {
        get { self[MarkupConfigurationKey.self] }
        set { self[MarkupConfigurationKey.self] = newValue }
    }
}
