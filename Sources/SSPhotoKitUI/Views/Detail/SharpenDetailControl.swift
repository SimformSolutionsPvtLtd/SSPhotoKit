//
//  SharpenDetailControl.swift
//
//
//  Created by Krunal Patel on 08/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct SharpenDetailControl: View {
    
    @Binding var sharpen: SharpenFilter
    let onChange: () -> Void
    
    var body: some View {
        VStack {
            SSSlider(value: $sharpen.radius,
                     in: sharpen.$radius) {
                Text("Radius")
            }

            SSSlider(value: $sharpen.amount,
                     in: sharpen.$amount) {
                Text("Amount")
            }
        }
        .onChange(of: sharpen) { _ in
            onChange()
        }
        .onAppear {
            onChange()
        }
    }
}
