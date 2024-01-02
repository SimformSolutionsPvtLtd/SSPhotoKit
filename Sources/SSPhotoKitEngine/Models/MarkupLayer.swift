//
//  MarkupLayer.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//

public enum MarkupLayer : Identifiable, Hashable {
        
    case text(TextModel)
    case drawing(DrawModel)
    case sticker(StickerModel)
    
    public var id: String {
        switch self {
        case .text(let textModel):
            textModel.id
        case .drawing(let drawModel):
            drawModel.id
        case .sticker(let stickerModel):
            stickerModel.id
        }
    }
}


