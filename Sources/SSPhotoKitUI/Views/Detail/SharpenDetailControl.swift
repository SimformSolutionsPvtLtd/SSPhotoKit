//
//  SharpenDetailControl.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 08/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

struct SharpenDetailControl: View {
    
    // MARK: - Vars & Lets
    @Binding var sharpen: SharpenFilter
    let onChange: () -> Void
    
    // MARK: - Body
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
