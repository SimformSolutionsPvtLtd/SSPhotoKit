//
//  File.swift
//  
//
//  Created by Krunal Patel on 03/01/24.
//

import CoreImage

public struct RotateEditingCommand : EditingCommand {
    
    public var angle: CGFloat
    
    public func apply(to image: CIImage) -> CIImage {
        return image.rotating(angle)
    }
    
    public init(angle: CGFloat) {
        self.angle = angle
    }
}
