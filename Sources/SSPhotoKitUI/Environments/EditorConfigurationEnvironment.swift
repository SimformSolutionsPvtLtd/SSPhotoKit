//
//  EditorConfiguration.swift
//  SSPhotoKitUI
//
//  Created by Krunal Patel on 12/01/24.
//

import SwiftUI

struct EditorConfigurationKey: EnvironmentKey {
    
    static let defaultValue: EditorConfiguration = .init()
}


extension EnvironmentValues {
    
    var editorConfiguration: EditorConfiguration {
        get { self[EditorConfigurationKey.self] }
        set { self[EditorConfigurationKey.self] = newValue }
    }
}
