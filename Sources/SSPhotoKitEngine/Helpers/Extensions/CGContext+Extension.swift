//
//  CGContext+Extension.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreGraphics

// MARK: - Render
extension CGContext {
    
    public func render(renderer: (CGContext) -> Void) {
        renderer(self)
    }
}
