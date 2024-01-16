//
//  EditorConfigurationEnvironment.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 12/01/24.
//

import SwiftUI

// MARK: - EnvironmentKey
struct EditorConfigurationKey: EnvironmentKey {
    
    static let defaultValue: EditorConfiguration = .init()
}

// MARK: - EnvironmentValue
extension EnvironmentValues {
    
    var editorConfiguration: EditorConfiguration {
        get { self[EditorConfigurationKey.self] }
        set { self[EditorConfigurationKey.self] = newValue }
    }
}
