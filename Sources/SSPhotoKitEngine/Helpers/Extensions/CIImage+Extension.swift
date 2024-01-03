//
//  File.swift
//  
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
    
    public func resizing(_ size: CGSize) -> CIImage {
        
        let imageWidth = self.size.width
        let imageHeight = self.size.height
        let scale: CGFloat
        
        if (size.width < size.height) {
            scale = size.width / imageWidth
        } else {
            scale = size.height / imageHeight
        }
        
        return self.transformed(by: .init(scaleX: scale, y: scale))
            .removingExtentOffset()
    }
    
    public func resizedSmooth(_ size: CGSize) -> CIImage {
        let filter = CIFilter.lanczosScaleTransform()
        let scale = size.height / (extent.height)
        let aspectRatio = 1//size.width / ((extent.width) * scale)
        
        filter.inputImage = self
        filter.aspectRatio = Float(aspectRatio)
        filter.scale = Float(scale)
        
        guard let outputImage = filter.outputImage else { return self }
        
        return outputImage.cropped(to: outputImage.extent)
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
    
    
    func flipping(scaleX x: CGFloat, scaleY y: CGFloat) -> CIImage {
        
        guard x != 1 || y != 1  else {
            return self
        }
        
        var transform = CGAffineTransform(translationX: size.width / 2,
                                          y: size.height / 2)
        
        transform = transform.scaledBy(x: x, y: y)
        
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
