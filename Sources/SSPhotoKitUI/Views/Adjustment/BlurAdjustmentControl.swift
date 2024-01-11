//
//  BlurAdjustmentControl.swift
//
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct BlurAdjustmentControl: View {
    
    @Binding var blur: GaussianBlurFilter
    let onChange: () -> Void
    
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
