//
//  MarkupConfigurationEnvironment.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 15/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

// MARK: - EnvironmentKey
struct MarkupConfigurationKey: EnvironmentKey {
    
    static let defaultValue: MarkupConfiguration = .init()
}

// MARK: - EnvironmentValue
extension EnvironmentValues {
    
    var markupConfiguration: MarkupConfiguration {
        get { self[MarkupConfigurationKey.self] }
        set { self[MarkupConfigurationKey.self] = newValue }
    }
}
