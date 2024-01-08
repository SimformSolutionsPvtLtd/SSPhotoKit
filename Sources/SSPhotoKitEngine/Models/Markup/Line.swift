//
//  Line.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 02/01/24.
//

import SwiftUI

public struct Line: Hashable {
    
    public var path: [CGPoint]
    public var brush: Brush
    
    // MARK: - Initializer
    public init(path: [CGPoint] = [], brush: Brush) {
        self.path = path
        self.brush = brush
    }
}
