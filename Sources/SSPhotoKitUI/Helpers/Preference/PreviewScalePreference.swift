//
//  PreviewScalePreference.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 09/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

struct PreviewScalePreference: PreferenceKey {
    
    static var defaultValue: CGSize = .one
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        
    }
}

struct PreviewOffsetPreference: PreferenceKey {
    
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        
    }
}

struct PreviewFramePreference: PreferenceKey {
    
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        
    }
}
