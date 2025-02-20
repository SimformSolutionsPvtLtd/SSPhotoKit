//
//  BlurAdjustmentControl.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

struct BlurAdjustmentControl: View {
    
    // MARK: - Vars & Lets
    @Binding var blur: GaussianBlurFilter
    let onChange: () -> Void
    
    // MARK: - Body
    var body: some View {
        
        SSSlider(value: $blur.radius,
                 in: blur.$radius)
            .onChange(of: blur.radius) { _ in
                onChange()
            }
            .onAppear {
                onChange()
            }
    }
}
