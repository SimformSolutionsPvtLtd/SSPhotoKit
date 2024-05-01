//
//  EditorConfiguration.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 12/01/24.
//

public struct EditorConfiguration {
    
    // MARK: - Vars & Lets
    public var allowedEditors: AllowedEditorOptions
    
    // MARK: - Initializer
    public init(allowedEditors: AllowedEditorOptions = .all) {
        self.allowedEditors = allowedEditors
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
