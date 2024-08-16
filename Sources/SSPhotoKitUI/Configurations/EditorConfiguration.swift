//
//  EditorConfiguration.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 12/01/24.
//

import SwiftUI

public struct EditorConfiguration {
    
    // MARK: - Vars & Lets
    public var allowedEditors: AllowedEditorOptions
    public var theme: Theme
    
    // MARK: - Initializer
    public init(allowedEditors: AllowedEditorOptions = .all, theme: Theme = .init()) {
        self.allowedEditors = allowedEditors
        self.theme = theme
    }
}

// MARK: - Options
extension EditorConfiguration {
    
    public struct AllowedEditorOptions: OptionSet {
        
        public var rawValue: UInt32
        
        public static let crop = AllowedEditorOptions(rawValue: 1 << 0)
        public static let adjustment = AllowedEditorOptions(rawValue: 1 << 1)
        public static let filter = AllowedEditorOptions(rawValue: 1 << 2)
        public static let detail = AllowedEditorOptions(rawValue: 1 << 3)
        public static let markup = AllowedEditorOptions(rawValue: 1 << 4)
        
        public static let all: AllowedEditorOptions = [.crop, .adjustment, .filter, .detail, .markup]
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
    }
}

// MARK: - Theme
extension EditorConfiguration {
    
    public struct Theme {
        let menuBackground: AnyShapeStyle
        let menuForeground: AnyShapeStyle
        
        // MARK: - Initializer
        public init(menuBackground: some ShapeStyle = .black, menuForeground: some ShapeStyle = .white) {
            self.menuBackground = AnyShapeStyle(menuBackground)
            self.menuForeground = AnyShapeStyle(menuForeground)
        }
    }
}
