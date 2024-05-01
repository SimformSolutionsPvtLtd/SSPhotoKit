//
//  Image+Extension.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 02/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
@_exported import typealias SSPhotoKitEngine.PlatformImage
#endif

extension Image {
    
    public init(platformImage: PlatformImage) {
        #if os(iOS)
        self.init(uiImage: platformImage)
        #else
        self.init(nsImage: platformImage)
        #endif
    }
}
