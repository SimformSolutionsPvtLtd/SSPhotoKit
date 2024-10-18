//
//  DrawingMarkupItem.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 08/01/24.
//

import CoreGraphics

// MARK: - DrawingMarkupItem
public struct DrawingMarkupItem: MarkupItem {
    
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
        updateLines(scale: scale, inverting: true)
    }
    
    public mutating func updateLines(scale: CGSize = .one, offset: CGSize = .zero, inverting: Bool = false) {
        for index in lines.indices {
            
            if inverting {
                lines[index].brush.width *= scale.width
            } else {
                lines[index].brush.width /= scale.width
            }
            
            lines[index].path = lines[index].path
                .map {
                    var point: CGPoint = .zero
                    if inverting {
                        point.x = ($0.x * scale.width) + offset.width
                        point.y = ($0.y * scale.height) + offset.height
                    } else {
                        point.x = ($0.x - offset.width) / scale.width
                        point.y = ($0.y - offset.height) / scale.height
                    }
                    
                    return point
                }
        }
    }
    
    public mutating func update(scale: CGSize = .one, offset: CGSize = .zero, center: CGSize = .zero, inverting: Bool = false) {
        for index in lines.indices {
            if inverting {
                lines[index].brush.width *= scale.width
            } else {
                lines[index].brush.width /= scale.width
            }
            
            lines[index].path = lines[index].path
                .map {
                    var point: CGPoint = .zero
                    if inverting {
                        let newOffset = (($0.toCGSize() - center) * scale) + center + offset
                        point = newOffset.toCGPoint()
                    } else {
                        let newOffset = (($0.toCGSize() - center - offset) / scale) + center
                        point = newOffset.toCGPoint()
                    }
                    return point
                }
        }
    }
    
    // MARK: - Initializer
    public init(lines: [Line] = []) {
        self.lines = lines
    }
}
