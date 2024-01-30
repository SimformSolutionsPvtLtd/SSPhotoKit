//
//  Constants.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//

#if os(iOS)
import UIKit
public typealias PlatformImage = UIImage
#elseif os(macOS)
import AppKit
public typealias PlatformImage = NSImage
#endif

#if os(macOS)
import AppKit
extension NSImage {
    
    public var cgImage: CGImage? {
        get {
            let imageData = self.tiffRepresentation!
            let source = CGImageSourceCreateWithData(imageData as CFData, nil).unsafelyUnwrapped
            let maskRef = CGImageSourceCreateImageAtIndex(source, Int(0), nil)
            return maskRef
        }
    }
    
    public convenience init(cgImage: CGImage) {
        self.init(cgImage: cgImage, size: cgImage.size)
    }
}
#endif


