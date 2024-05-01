//
//  ContentView.swift
//  SSPhotoKitDemo
//
//  Created by Krunal Patel on 09/01/24.
//

import SwiftUI
import SSPhotoKitUI

struct ContentView: View {
    
    @State var image: PlatformImage?
    
    private var stickers: [PlatformImage] = [
        PlatformImage(resource: .skull),
        PlatformImage(resource: .witch),
        PlatformImage(resource: .witch2),
        PlatformImage(resource: .joker),
        PlatformImage(resource: .ghost)
    ]
    
    var body: some View {
        VStack {
            Spacer()
            
            if let image {
                Image(platformImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(maxWidth: .infinity)
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .opacity(0.6)
                    .frame(maxWidth: .infinity)
            }
            Spacer()
            
            SSPKImagePicker(image: $image) {
                Text("Pick Image")
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .cropConfig(ratios: [.init(height: 1, width: 1)],
                        options: [.custom],
                        labelType: .iconWithText)
            .adjustmentConfig(allowedAdjustments: [.light])
            .markupConfig(stickers: stickers, stickerOptions: [.gallery])
        }
    }
}

#Preview {
    ContentView()
}
