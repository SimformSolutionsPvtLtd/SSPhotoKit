//
//  StickerMarkup.swift
//
//
//  Created by Krunal Patel on 05/01/24.
//

import SwiftUI
import PhotosUI
import SSPhotoKitEngine

struct StickerMarkup<Content, Menu>: View where Content : View, Menu : View{
    
    @Binding var layers: [MarkupLayer]
    @Binding var index: Int?
    let onDiscard: () -> Void
    let onSave: () -> Void
    let rearrangeMenu: Menu?
    @ViewBuilder var content: Content
    
    @State private var isEditing: Bool = true
    @State private var item: PhotosPickerItem?
    @State private var lastOrigin: CGPoint = .zero
    
    var body: some View {
        
        ZStack {
            content
                .overlay {
                    if let index {
                        MarkupLayerView(layers: layers, selection: index) {
                            SelectionOverlay(currentRotation: $layers[index].sticker.rotation,
                                             currentSize: $layers[index].sticker.size, onUpdate: handleUpdate)
                        }
                    }
                }
        }
        .gesture(dragGesture)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .photosPicker(isPresented: $isEditing, selection: $item)
        .overlay(alignment: .top) {
            headerMenu
        }
        .onChange(of: item) { item in
            if let item {
                loadImage(for: item)
            }
        }
        .onAppear {
            isEditing = index == nil
            
            if index == nil {
                index = layers.count
                layers.append(.sticker(.init()))
            }
            lastOrigin = layers[index!].sticker.origin
        }
    }
    
    // MARK: - Initializer
    init(layers: Binding<[MarkupLayer]>, index: Binding<Int?>, onSave: @escaping () -> Void, onDiscard: @escaping () -> Void, @ViewBuilder content: () -> Content, @ViewBuilder menu: () -> Menu) {
        self._layers = layers
        self._index = index
        self.onSave = onSave
        self.onDiscard = onDiscard
        self.content = content()
        self.rearrangeMenu = menu()
    }
    
    init(layers: Binding<[MarkupLayer]>, index: Binding<Int?>, onSave: @escaping () -> Void, onDiscard: @escaping () -> Void, @ViewBuilder content: () -> Content) where Menu == EmptyView {
        self._layers = layers
        self._index = index
        self.onSave = onSave
        self.onDiscard = onDiscard
        self.rearrangeMenu = nil
        self.content = content()
    }
}

// MARK: - Views
extension StickerMarkup {
    
    @ViewBuilder
    private var headerMenu: some View {
        HStack {
            Button {
                onDiscard()
            } label: {
                Image(systemName: "xmark")
            }

            Spacer()
            
            if let rearrangeMenu {
                rearrangeMenu
            }
            
            Spacer()
            
            Button {
                onSave()
            } label: {
                Image(systemName: "checkmark")
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Gestures
extension StickerMarkup {
    
    private var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .local)
            .onChanged { value in
                guard let index else { return }
                
                layers[index].sticker.origin = lastOrigin + CGPoint(x: value.translation.width, y: value.translation.height)
            }
            .onEnded { value in
                guard let index else { return }
                
                lastOrigin = layers[index].sticker.origin
            }
    }
}

// MARK: - Methods
extension StickerMarkup {
    
    private func loadImage(for item: PhotosPickerItem) {
        Task {
            guard let index,
                  let data = try? await item.loadTransferable(type: Data.self),
                  let image = PlatformImage(data: data)?.cgImage
            else { return }
            
            await MainActor.run {
                layers[index].sticker.image = image
            }
        }
    }
    
    private func handleUpdate(for action: SelectionAction) {
        switch action {
        case .delete:
            if let index {
                layers.remove(at: index)
            }
            index = nil
        case .edit:
            isEditing = true
        default:
            break
        }
    }
}
