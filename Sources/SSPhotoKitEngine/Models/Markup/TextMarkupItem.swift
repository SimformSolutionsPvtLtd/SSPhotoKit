//
//  TextMarkupItem.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 08/01/24.
//

import SwiftUI

// MARK: - TextMarkupItem
public struct TextMarkupItem: MarkupItem {
    
    // MARK: - Vars & Lets
    public var text: String
    
    public var fontName: String = Constants.Markup.fontName
    
    public var fontSize: CGFloat = Constants.Markup.fontSize
    
    public var color: Color = .white
    
    public var size: CGSize = Constants.Markup.size {
        didSet {
            fontSize = size.width
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
    
    // MARK: - Initializer
    public init(_ text: String = "") {
        self.text = text
    }
}
