//
//  MarkupLayer.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreGraphics

public enum MarkupLayer : Identifiable, Hashable {
    
    case text(TextMarkupItem)
    case drawing(DrawingMarkupItem)
    case sticker(StickerMarkupItem)
    
    public var id: String {
        switch self {
        case .text(let textMarkupItem):
            textMarkupItem.id
        case .drawing(let drawingMarkupItem):
            drawingMarkupItem.id
        case .sticker(let stickerMarkupItem):
            stickerMarkupItem.id
        }
    }
}

extension MarkupLayer {
    
    public var sticker: StickerMarkupItem {
        get {
            if case let .sticker(data) = self {
                return data
            } else {
                return .init()
            }
        }
        mutating set {
            self = .sticker(newValue)
        }
    }
    
    public var drawing: DrawingMarkupItem {
        get {
            if case let .drawing(data) = self {
                return data
            } else {
                return .init()
            }
        }
        mutating set {
            self = .drawing(newValue)
        }
    }
    
    public var text: TextMarkupItem {
        get {
            if case let .text(data) = self {
                return data
            } else {
                return .init()
            }
        }
        mutating set {
            self = .text(newValue)
        }
    }
}


extension MarkupLayer {
    
    public var scale: CGSize {
        get {
            switch self {
            case .text(let textMarkupItem):
                textMarkupItem.scale
            case .drawing(let drawingMarkupItem):
                drawingMarkupItem.scale
            case .sticker(let stickerMarkupItem):
                stickerMarkupItem.scale
            }
        }
        
        mutating set {
            switch self {
            case .text(_):
                text.updateScale(newValue)
            case .drawing(_):
                drawing.updateScale(newValue)
            case .sticker(_):
                sticker.updateScale(newValue)
            }
        }
        
    }
    
    public var item: any MarkupItem {
        get {
            switch self {
            case .text(let textMarkupItem):
                return textMarkupItem
            case .drawing(let drawingMarkupItem):
                return drawingMarkupItem
            case .sticker(let stickerMarkupItem):
                return stickerMarkupItem
            }
        }
        
        set {
            switch self {
            case .text(let textMarkupItem):
                text = (newValue as? TextMarkupItem) ?? textMarkupItem
            case .drawing(let drawingMarkupItem):
                drawing = (newValue as? DrawingMarkupItem) ?? drawingMarkupItem
            case .sticker(let stickerMarkupItem):
                sticker = (newValue as? StickerMarkupItem) ?? stickerMarkupItem
            }
        }
    }
}
