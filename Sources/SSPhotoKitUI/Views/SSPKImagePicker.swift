//
//  SSPKImagePicker.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 09/01/24.
//

import SwiftUI
import PhotosUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

public struct SSPKImagePicker<Content>: View where Content: View {
    
    // MARK: - Vars & Lets
    let label: Content
    @Binding var image: PlatformImage?
    @State private var pickerItem: PhotosPickerItem?
    @State private var editorPresent = false
    @State private var isPickerPresented = false
    @State private var editingImage = PlatformImage()
    
    // MARK: - Body
    public var body: some View {
        Button {
            isPickerPresented = true
        } label: {
            label
        }
        .photosPicker(isPresented: $isPickerPresented, selection: $pickerItem, matching: .images)
        .presentEditor(isPresented: $editorPresent) {
            editorView
        }
        .onChange(of: pickerItem) { _ in
            if let pickerItem {
                loadImage(pickerItem)
            }
        }
        .onChange(of: editorPresent) { _ in
            image = editingImage
        }
    }
    
    // MARK: - Initializer
    public init(image: Binding<PlatformImage?>, @ViewBuilder label: () -> Content) {
        self.label = label()
        _image = image
    }
}

// MARK: - Methods
extension SSPKImagePicker {
    
    private func loadImage(_ item: PhotosPickerItem) {
        Task {
            guard let data = try? await item.loadTransferable(type: Data.self),
                  let image = PlatformImage(data: data) else {
                return
            }
            
            editingImage = image
            editorPresent = true
        }
    }
    
    @ViewBuilder
    private var editorView: some View {
        #if os(iOS)
        GeometryReader { proxy in
            SSPKEditorView(image: $editingImage, isPresented: $editorPresent, previewSize: proxy.size)
        }
        #elseif os(macOS)
        SSPKEditorView(image: $editingImage, isPresented: $editorPresent, previewSize: CGSize(width: 500, height: 500))
            .frame(minWidth: 500, minHeight: 800)
        #endif
    }
}
