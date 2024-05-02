//
//  EditorDemo.swift
//  SSPhotoKitDemo
//
//  Created by Krunal Patel on 02/05/24.
//

import SwiftUI
import PhotosUI
import SSPhotoKit

struct EditorDemo: View {
    
    // MARK: - Vars & Lets
    @State private var image: PlatformImage = .snape
    @State private var pickerItem: PhotosPickerItem?
    @State private var isEditorPresent = false
    @State private var isPickerPresent = false
    
    // MARK: - Body
    var body: some View {
        Group {
            if isEditorPresent {
                GeometryReader { proxy in
                    SSPKEditorView(image: $image, isPresented: $isEditorPresent, previewSize: proxy.size)
                }
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    Image(platformImage: image)
                        .resizable()
                        .scaledToFit()
                    Spacer()
                    options
                }
            }
        }
        .photosPicker(isPresented: $isPickerPresent, selection: $pickerItem, matching: .images)
        .onChange(of: pickerItem) { _ in
            if let pickerItem {
                loadImage(pickerItem)
            }
            pickerItem = nil
        }
    }
}

// MARK: - Views
extension EditorDemo {
    
    // Options
    @ViewBuilder
    private var options: some View {
        HStack(spacing: 18) {
            Button {
                isEditorPresent = true
            } label: {
                Image(systemName: "paintbrush.pointed.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
            }
            
            Button {
                isPickerPresent = true
            } label: {
                Image(systemName: "photo.badge.plus.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .buttonStyle(.primary)
        .background()
    }
}

// MARK: - Methods
extension EditorDemo {
    
    private func loadImage(_ item: PhotosPickerItem) {
        Task {
            guard let data = try? await item.loadTransferable(type: Data.self),
                  let image = PlatformImage(data: data) else {
                return
            }
            
            self.image = image
        }
    }
}
