//
//  MarkupModels.swift
//  
//
//  Created by Krunal Patel on 02/01/24.
//

import Foundation
import CoreGraphics

// MARK: - DrawModel
public struct DrawModel : Identifiable, Hashable {
    
    public let id: String = UUID().uuidString
    
    public var lines: [Line]
}

// MARK: - TextModel
public struct TextModel : Identifiable, Hashable {
    
    public let id: String = UUID().uuidString
    
    public var text: String
    
    public var extent: CGRect = CGRect(x: 50, y: 50, width: 100, height: 100)
    
    public var rotation: CGFloat = 0
    
    public var fontName: String = "AppleSymbols"
    
    public var fontSize: CGFloat = 20
    
    public var size: CGSize {
        get {
            extent.size
        }
        set {
            extent.size = newValue
        }
    }
    
    public var origin: CGPoint {
        get {
            extent.origin
        }
        set {
            extent.origin = newValue
        }
    }
    
}

// MARK: - StickerModel
public struct StickerModel : Identifiable, Hashable {
    
    public let id: String = UUID().uuidString
    
    public var image: CGImage {
        didSet {
            previewImage = image.resize(extent.size)
        }
    }
    
    public var extent: CGRect {
        didSet {
            if extent.size != oldValue.size {
                previewImage = image.resize(extent.size)
            }
        }
    }
    
    public var scale: CGSize {
        image.size / previewImage.size
    }
    
    public var rotation: CGFloat = 0
    
    public var size: CGSize {
        get {
            extent.size
        }
        set {
            extent.size = newValue
        }
    }
    
    public var origin: CGPoint {
        get {
            extent.origin
        }
        set {
            extent.origin = newValue
        }
    }
    
    public private(set) var previewImage: CGImage
    
    // MARK: - Initializer
    public init(image: CGImage, extent: CGRect? = nil) {
        self.image = image
        self.extent = extent ?? CGRect(x: 50, y: 50, width: 100, height: 100)
        previewImage = image.resize(self.extent.size)
    }
}
