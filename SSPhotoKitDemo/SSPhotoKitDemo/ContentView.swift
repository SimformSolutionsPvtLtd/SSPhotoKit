//
//  ContentView.swift
//  SSPhotoKitDemo
//
//  Created by Krunal Patel on 09/01/24.
//

import SwiftUI
import SSPhotoKit

struct ContentView: View {
    
    // MARK: - Vars & Lets
    @State var image: PlatformImage = .snape
    @State var isPresented: Bool = true
    
    // MARK: - Body
    var body: some View {
        if isPresented {
            GeometryReader { proxy in
                SSPKEditorView(image: $image, isPresented: $isPresented, previewSize: proxy.size)
            }
        } else {
            Image(platformImage: image)
                .resizable()
        }
    }
}
