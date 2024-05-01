//
//  MarkupConfiguration.swift
//
//
//  Created by Krunal Patel on 15/01/24.
//

import SSPhotoKitEngine

public struct MarkupConfiguration {
    
    // MARK: - Vars & Lets
    public var customStickers: [PlatformImage]
    
    public var stickerOptions: StickerOptions
    
    public var allowedMarkups: AllowedMarkupOptions
    
    // MARK: - Initializer
    public init(customStickers: [PlatformImage] = [],
                stickerOptions: StickerOptions = .gallery,
                allowedMarkups: AllowedMarkupOptions = .all) {
        self.customStickers = customStickers
        self.stickerOptions = stickerOptions
        self.allowedMarkups = allowedMarkups
    }
}

// MARK: - Options
extension MarkupConfiguration {
    
    public struct StickerOptions: OptionSet {
        
        public var rawValue: UInt32
        
        public static let custom = StickerOptions(rawValue: 1 << 0)
        public static let gallery = StickerOptions(rawValue: 1 << 1)
        
        public static let all: StickerOptions = [.custom, .gallery]
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
    }
    
    public struct AllowedMarkupOptions : OptionSet {
        
        public var rawValue: UInt32
        
        public static let drawing = AllowedMarkupOptions(rawValue: 1 << 0)
        public static let text = AllowedMarkupOptions(rawValue: 1 << 1)
        public static let sticker = AllowedMarkupOptions(rawValue: 1 << 2)
        
        public static let all: AllowedMarkupOptions = [.drawing, .text, .sticker]
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
    }
}
