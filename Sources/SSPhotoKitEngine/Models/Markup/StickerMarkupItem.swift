//
//  StickerMarkupItem.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 08/01/24.
//

import CoreGraphics

// MARK: - StickerMarkupItem
public struct StickerMarkupItem : MarkupItem {
    
    // MARK: - Vars & Lets
    public var image: CGImage {
        didSet {
            updatePreview()
        }
    }
    
    public private(set) var previewImage: CGImage
    
    public var size: CGSize = Constants.Markup.size {
        didSet {
            updatePreview()
        }
    }
    
    public var origin: CGPoint = Constants.Markup.origin
    
    public var rotation: CGFloat = Constants.Markup.rotation
    
    public var scale: CGSize = Constants.Markup.scale
    
    // MARK: - Methods
    public mutating func updateScale(_ scale: CGSize) {
        self.scale = scale
        updateExtent()
    }
    
    private mutating func updatePreview() {
        previewImage = image.resize(size)
    }
    
    // MARK: - Initializer
    public init(_ image: CGImage? = nil) {
        self.image = image ?? Constants.Markup.stickerImage
        previewImage = self.image.resize(size)
    }
    
    public init(platformImage: PlatformImage) {
        self.init(platformImage.cgImage)
    }
}
