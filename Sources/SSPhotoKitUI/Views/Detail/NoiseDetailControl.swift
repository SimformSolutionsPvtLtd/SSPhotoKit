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
            SSSlider(value: $noise.noiseLevel,
                     in: noise.$noiseLevel) {
                Text("Noise Level")
            }

            SSSlider(value: $noise.sharpness,
                     in: noise.$sharpness) {
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
