//
//  Constants.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 08/01/24.
//

import CoreGraphics

enum Constants {
    
    enum Markup {
        static let size = CGSize(width: 100, height: 100)
        static let origin = CGPoint(x: 50, y: 100)
        static let rotation: CGFloat = 0
        static let scale: CGSize = .one
        
        static let fontName = "AppleSymbols"
        static let fontSize: CGFloat = 100
        
        static let stickerImage: CGImage = PlatformImage(systemName: "photo")!.cgImage!
    }
}
