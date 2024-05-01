//
//  File.swift
//  
//
//  Created by Krunal Patel on 09/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct PreviewScalePreference : PreferenceKey {
    
    static var defaultValue: CGSize = .one
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
//        value = nextValue()
    }
}

struct PreviewOffsetPreference : PreferenceKey {
    
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
//        value += nextValue()
    }
}

struct PreviewFramePreference : PreferenceKey {
    
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value += nextValue()
    }
}
