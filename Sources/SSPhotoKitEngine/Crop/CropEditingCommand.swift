//
//  CropEditingCommand.swift
//
//
//  Created by Krunal Patel on 03/01/24.
//

import CoreImage

public struct CropEditingCommand : EditingCommand {
    
    public var rect: CGRect
    public var angle: CGFloat = .zero
    public var flipScale: CGSize = CGSize(width: 1, height: 1)
    
    public func apply(to image: CIImage) -> CIImage {
        
        return image
            .rotating(angle)
            .flipping(scaleX: flipScale.width, scaleY: flipScale.height)
            .cropped(to: rect)
    }
    
    public init(rect: CGRect) {
        self.rect = rect
    }
}
