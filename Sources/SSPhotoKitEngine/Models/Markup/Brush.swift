//
//  Brush.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 08/01/24.
//

import SwiftUI

public struct Brush: Hashable {
   
    public let style: Style
    public var width: CGFloat
    public var color: Color
    
    // MARK: - Initializer
    public init(style: Style, width: CGFloat? = nil, color: Color = .blue) {
        self.style = style
        self.width = width ?? (style.maxWidth - style.minWidth)/2
        self.color = color
    }
    
}

// MARK: - Brush+Enums
extension Brush {
    
    // MARK: - Style
    public enum Style: String {
        case pen
        case brush
        case neon
        case pencil
        case eraser
    }
}

extension Brush {
    
    public var isAvailable: Bool {
        switch style {
        case .eraser, .pen: return true
        default: return false
        }
    }
    
    public static func defaultBrushes() -> [Brush] {
        return [
            Brush(style: .pen),
            Brush(style: .brush),
            Brush(style: .neon),
            Brush(style: .pencil),
            Brush(style: .eraser)
        ]
    }
      
    
}

extension Brush.Style {
    
    public var contentScale: CGFloat {
        return 1
    }
    
    public var maxWidth: CGFloat {
        switch self {
        case .eraser:
            return 50 * contentScale
        default:
            return 40 * contentScale
        }
    }
    
    public var minWidth: CGFloat {
        switch self {
        case .eraser:
            return 25 * contentScale
        default:
            return 13 * contentScale
        }
    }
}
