//
//  NoiseDetailControl.swift
//
//
//  Created by Krunal Patel on 08/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct NoiseDetailControl: View {
    
    @Binding var noise: NoiseFilter
    let onChange: () -> Void
    
    var body: some View {
        
        VStack {
            SSSlider(value: $noise.noiseLevel.value,
                     in: noise.noiseLevel.range) {
                Text("Noise Level")
            }

            SSSlider(value: $noise.sharpness.value,
                     in: noise.sharpness.range) {
                Text("Sharpness")
            }
        }
        .onChange(of: noise) { _ in
            onChange()
        }
        .onAppear {
            onChange()
        }
    }
}
