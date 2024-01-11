//
//  File.swift
//  
//
//  Created by Krunal Patel on 02/01/24.
//

import SwiftUI
@_exported import typealias SSPhotoKitEngine.PlatformImage

extension Image {
    
    public init(platformImage: PlatformImage) {
        #if os(iOS)
        self.init(uiImage: platformImage)
        #else
        self.init(nsImage: platformImage)
        #endif
    }
}

