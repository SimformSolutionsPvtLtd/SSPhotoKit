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
