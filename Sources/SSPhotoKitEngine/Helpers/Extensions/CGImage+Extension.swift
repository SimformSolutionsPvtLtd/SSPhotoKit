//
//  CGImage+Extension.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreGraphics

// MARK: - Rotating
extension CGImage {
    
    // MARK: - Rotating
    /// Rotate image to specific angle and optionally flip image.
    ///
    /// - Parameters:
    ///   - angle: angle description
    ///   - flip: flip description
    /// - Returns: description
    public func rotated(_ angle: CGFloat = 0, flip: FlipDirection? = nil) -> CGImage {
        
        guard angle != 0 || flip != nil else {
            return self
        }
        
        let absAngle = abs(.pi/2 - abs(angle))
        let rotatedSize = CGSize(width: sin(absAngle) * size.width + cos(absAngle) * size.height,
                                 height: cos(absAngle) * size.width + sin(absAngle) * size.height)
        
        guard let context = makeContext(size: rotatedSize) else { return self }
        
        context.render { ctx in
            // Move CGContext origin to centre of the image.
            ctx.translateBy(x: rotatedSize.width / 2,
                            y: rotatedSize.height / 2)
            
            // Flip context
            if let flip {
                switch flip {
                case .horizontal:
                    ctx.scaleBy(x: -1, y: 1)
                case .vertical:
                    ctx.scaleBy(x: 1, y: -1)
                }
            }
            
            ctx.rotate(by: angle)
            // Reset CGContext origin to start of the image.
            ctx.translateBy(x: -CGFloat(width) / 2,
                            y: -CGFloat(height) / 2)
            
            ctx.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        return context.makeImage() ?? self
    }
}

// MARK: - Resizing
extension CGImage {
    
    public func resizing(_ size: CGSize) -> CGImage {
        
        var ratio: CGFloat = 0.0
        let imageWidth = CGFloat(width)
        let imageHeight = CGFloat(height)
        
        // Get ratio (landscape or portrait)
        if imageWidth > imageHeight {
            ratio = size.width / imageWidth
        } else {
            ratio = size.height / imageHeight
        }
        
        // Calculate new size based on the ratio
        if ratio > 1 {
            ratio = 1
        }
        
        let width = imageWidth * ratio
        let height = imageHeight * ratio
        
        guard let context = makeContext(size: CGSize(width: width, height: height)) else { return self }
        
        // draw image to context (resizing it)
        context.interpolationQuality = .high
        context.draw(self, in: CGRect(origin: .zero, size: size))
        
        // extract resulting image from context
        return context.makeImage() ?? self
        
    }
}

// MARK: - Context
extension CGImage {
    
    public func makeContext(size: CGSize) -> CGContext? {
        CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: 0,
            space: colorSpace!,
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrderDefault.rawValue
        )
    }
}

// MARK: - Size
extension CGImage {
    
    public var size: CGSize {
        CGSize(width: width, height: height)
    }
}
