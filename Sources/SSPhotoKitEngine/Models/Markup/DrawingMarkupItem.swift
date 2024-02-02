//
//  DrawingMarkupItem.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 08/01/24.
//

import CoreGraphics

// MARK: - DrawingMarkupItem
public struct DrawingMarkupItem : MarkupItem {
    
    // MARK: - Vars & Lets
    public var lines: [Line]
    
    public var size: CGSize = Constants.Markup.size
    
    public var origin: CGPoint = Constants.Markup.origin
    
    public var rotation: CGFloat = Constants.Markup.rotation
    
    public var scale: CGSize = Constants.Markup.scale
    
    // MARK: - Methods
    public mutating func updateScale(_ scale: CGSize) {
        self.scale = scale
        updateExtent()
        updateLines()
    }
    
    public mutating func updateLines() {
        for i in lines.indices {
            lines[i].brush.width *= scale.width
            
            lines[i].path = lines[i].path
                .map { CGPoint(x: $0.x * scale.width, y: $0.y * scale.height) }
        }
    }
    
    // MARK: - Initializer
    public init(lines: [Line] = []) {
        self.lines = lines
    }
}
