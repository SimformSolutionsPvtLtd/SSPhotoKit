//
//  Editor.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 02/01/24.
//

#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

// MARK: - Editor
enum Editor: String, CaseIterable, Identifiable {
    
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

// MARK: - Editor + Extension
extension Editor {
    
    static func getAllowedEditors(with options: EditorConfiguration.AllowedEditorOptions) -> [Editor] {
        Editor.allCases.filter { editor in
            switch editor {
            case .crop where options.contains(.crop):
                true
            case .adjustment where options.contains(.adjustment):
                true
            case .filter where options.contains(.filter):
                true
            case .detail where options.contains(.detail):
                true
            case .markup where options.contains(.markup):
                true
            default:
                false
            }
        }
    }
}

// MARK: - Crop
enum Crop: String, CaseIterable, Identifiable {
    
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

// MARK: - Adjustment
enum Adjustment: String, CustomStringConvertible, CaseIterable, Identifiable {
    
    case light, color, blur, none
    
    var id: String { rawValue }
    
    @inlinable
    var description: String {
        switch self {
        case .light:
            return "Light"
        case .color:
            return "Color"
        case .blur:
            return "Blur"
        case .none:
            return "Adjustment"
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

// MARK: - Adjustment + Extension
extension Adjustment {
    
    static func getAllowedAdjustments(with options: AdjustmentConfiguration.AllowedAdjustmentOptions) -> [Adjustment] {
        Adjustment.allCases.filter { adjustment in
            switch adjustment {
            case .light where !options.isDisjoint(with: .light):
                true
            case .color:
                false
            case .blur where options.contains(.blur):
                true
            default:
                false
            }
        }
    }
}

// MARK: - LightAdjustment
enum LightAdjustment: String, CustomStringConvertible, CaseIterable, Identifiable {
    
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

// MARK: - LightAdjustment + Extension
extension LightAdjustment {
    
    static func getAllowedLightAdjustments(with options: AdjustmentConfiguration.AllowedAdjustmentOptions) -> [LightAdjustment] {
        LightAdjustment.allCases.filter { adjustment in
            switch adjustment {
            case .brightness where options.contains(.brightness):
                true
            case .contrast where options.contains(.contrast):
                true
            case .saturation where options.contains(.saturation):
                true
            case .hue where options.contains(.hue):
                true
            default:
                false
            }
        }
    }
}

// MARK: - Detail
enum Detail: String, CustomStringConvertible, CaseIterable, Identifiable {
    
    case sharpen, noise
    
    var id: String { rawValue }
    
    @inlinable
    var description: String {
        switch self {
        case .sharpen:
            return "Sharpen"
        case .noise:
            return "Noise"
        }
    }
}

// MARK: - Markup
enum Markup: String, CustomStringConvertible, CaseIterable, Identifiable {
    
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
            "Markup"
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

// MARK: - Markup + Extension
extension Markup {
    
    static func getAllowedMarkups(with options: MarkupConfiguration.AllowedMarkupOptions) -> [Markup] {
        Markup.allCases.filter { markup in
            switch markup {
            case .drawing where options.contains(.drawing):
                true
            case .text where options.contains(.text):
                true
            case .sticker where options.contains(.sticker):
                true
            default:
                false
            }
        }
    }
}
