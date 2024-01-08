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
    
    public convenience init?(systemName name: String) {
        self.init(systemSymbolName: name, accessibilityDescription: nil)
    }
}
#endif

extension PlatformImage {
    
    #if os(iOS)
    public static func load(image name: String, from bundle: Bundle?) -> PlatformImage? {
        self.init(named: name, in: bundle, compatibleWith: nil)
    }
    #elseif os(macOS)
    public static func load(image name: String, from bundle: Bundle?) -> PlatformImage? {
        if let bundle {
            return bundle.image(forResource: name)
        } else {
            return self.init(named: name)
        }
    }
    #endif
    
}

