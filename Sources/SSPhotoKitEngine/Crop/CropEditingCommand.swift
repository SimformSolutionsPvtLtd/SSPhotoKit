//
//  CropEditingCommand.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 03/01/24.
//

import CoreImage

/// Editing command to perform crop, rotation and flip operation on image.
public struct CropEditingCommand: EditingCommand {
    
    // MARK: - Vars & Lets
    /// Area that will be cropped.
    public var rect: CGRect
    
    /// Angle in radian to ratate image.
    public var angle: CGFloat = .zero
    
    /// Flip scale to flip image.
    ///
    /// - To flip horizontally make with -1
    /// - To flip vertically make height -1
    ///
    /// Ex: `CGSize(width: -1, height: 1)` flips image horizontally.
    public var flipScale: CGSize = .one
    
    /// Scale corresponding to original image.
    public var scale: CGSize = .one
    
    // MARK: - Methods
    public func apply(to image: CIImage) -> CIImage {
        
        var scaledRect = rect
        scaledRect.size *= scale
        scaledRect.origin.x *= scale.width
        scaledRect.origin.y *= scale.height
        
        return image
            .flipping(scaleX: flipScale.width, scaleY: flipScale.height)
            .rotating(angle)
            .cropped(to: scaledRect)
            .removingExtentOffset()
    }
    
    // MARK: - Initializer
    public init(rect: CGRect) {
        self.rect = rect
    }
}
