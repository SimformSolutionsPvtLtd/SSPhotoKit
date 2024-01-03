//
//  File.swift
//  
//
//  Created by Krunal Patel on 03/01/24.
//

import CoreImage

public struct FlipEditingCommand : EditingCommand {
    
    public var horizontalFlip: Bool
    public var verticalFlip: Bool
    
    public func apply(to image: CIImage) -> CIImage {
        return image.transformed(
            by: .init(scaleX: horizontalFlip ? -1 : 1,
                      y: verticalFlip ? 1 : -1))
    }
    
    public init(horizontal: Bool, vertical: Bool) {
        self.horizontalFlip = horizontal
        self.verticalFlip = vertical
    }
}
