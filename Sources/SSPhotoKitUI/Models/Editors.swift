//
//  Enums.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//

enum Editor : String, CaseIterable, Identifiable {
    
    case crop, adjustment, filter, detail, markup, none
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .crop:
            return "crop"
        case .adjustment:
            return "slider.horizontal.3"
        case .filter:
            return "wand.and.stars.inverse"
        case .detail:
            return "circle.grid.cross.right.filled"
        case .markup:
            return "pencil.tip.crop.circle"
        case .none:
            return ""
        }
    }
}


enum Crop : String, CaseIterable, Identifiable {
    
    case aspect, rotation, transform
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .aspect:
            "Aspect Ration"
        case .rotation:
            "Rotation"
        case .transform:
            "Transform"
        }
    }
}

enum Adjustment : String, CaseIterable, Identifiable {
    
    case light, color, blur, none
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .light:
            return "Light"
        case .color:
            return "Color"
        case .blur:
            return "Blur"
        case .none:
            return "None"
        }
    }
    
    var icon: String {
        switch self {
        case .light:
            return "sun.max"
        case .color:
            return "wand.and.stars.inverse"
        case .blur:
            return "drop.fill"
        case .none:
            return ""
        }
    }
}

enum LightAdjustment : String, CustomStringConvertible, CaseIterable, Identifiable {
    
    case brightness, contrast, saturation, hue
    
    var id: String { rawValue }
    
    @inlinable
    var description: String {
        switch self {
        case .brightness:
            return "Brightness"
        case .contrast:
            return "Contrast"
        case .saturation:
            return "Saturation"
        case .hue:
            return "Hue"
        }
    }
    
    var icon: String {
        switch self {
        case .brightness:
            return ""
        case .contrast:
            return ""
        case .saturation:
            return ""
        case .hue:
            return ""
        }
    }
}

enum Markup : String, CustomStringConvertible, CaseIterable, Identifiable {
    
    case drawing, text, sticker, none
    
    var id: String { rawValue }
    
    @inlinable
    var description: String {
        switch self {
        case .drawing:
            "Drawing"
        case .text:
            "Text"
        case .sticker:
            "Sticker"
        case .none:
            "None"
        }
    }
    
    var icon: String {
        switch self {
        case .drawing:
            "paintbrush.pointed.fill"
        case .text:
            "character.cursor.ibeam"
        case .sticker:
            "photo.fill"
        case .none:
            ""
        }
    }
}
