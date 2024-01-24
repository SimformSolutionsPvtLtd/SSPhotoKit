//
//  ContentView.swift
//  SSPhotoKitDemo
//
//  Created by Krunal Patel on 02/01/24.
//

import SwiftUI
import SSPhotoKitUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
        }
        .padding()
        
        Text(SSPhotoKitUI.text2)
    }
}

#Preview {
    ContentView()
}
