//
//  NoiseDetailControl.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 08/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

struct NoiseDetailControl: View {
    
    // MARK: - Vars & Lets
    @Binding var noise: NoiseFilter
    let onChange: () -> Void
    
    // MARK: - Body
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
