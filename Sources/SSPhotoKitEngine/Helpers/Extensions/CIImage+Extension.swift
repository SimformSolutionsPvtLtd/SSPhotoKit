//
//  CIImage+Extension.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreImage

// MARK: - Size
extension CIImage {
    
    var size: CGSize {
        extent.size
    }
}

// MARK: - Resizing
extension CIImage {
    
    public func resizing(_ newSize: CGSize) -> CIImage {
        
        let widthRatio = newSize.width / size.width
        let heightRatio = newSize.height / size.height
        let scale = min(widthRatio, heightRatio)
        
        return self.transformed(by: .init(scaleX: scale, y: scale))
            .removingExtentOffset()
    }
}

// MARK: - Rotating
extension CIImage {
    
    func rotating(_ angle: CGFloat = 0, flip: FlipDirection? = nil) -> CIImage {
        
        guard angle != 0 || flip != nil else {
            return self
        }
        
        var transform = CGAffineTransform(translationX: size.width / 2,
                                          y: size.height / 2)
        
        if let flip {
            switch flip {
            case .horizontal:
                transform = transform.scaledBy(x: -1, y: 1)
            case .vertical:
                transform = transform.scaledBy(x: 1, y: -1)
            }
        }
        
        transform = transform.rotated(by: -angle)
        transform = transform.translatedBy(x: -CGFloat(size.width) / 2,
                                           y: -CGFloat(size.height) / 2)
        
        return transformed(by: transform)
    }
    
    func flipping(scaleX: CGFloat, scaleY: CGFloat) -> CIImage {
        
        guard scaleX != 1 || scaleY != 1  else {
            return self
        }
        
        var transform = CGAffineTransform(translationX: size.width / 2,
                                          y: size.height / 2)
        
        transform = transform.scaledBy(x: scaleX, y: scaleY)
        
        transform = transform.translatedBy(x: -CGFloat(size.width) / 2,
                                           y: -CGFloat(size.height) / 2)
        
        return transformed(by: transform)
    }
}

// MARK: - RemovingExtentOffset
extension CIImage {
    
    public func removingExtentOffset() -> CIImage {
        transformed(
            by: .init(
                translationX: -extent.origin.x,
                y: -extent.origin.y
            ))
    }
}
