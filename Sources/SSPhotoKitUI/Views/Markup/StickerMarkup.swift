//
//  StickerMarkup.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 05/01/24.
//

import SwiftUI
import PhotosUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

struct StickerMarkup<Content, Menu>: View where Content: View, Menu: View {
    
    // MARK: - Vars & Lets
    @Environment(\.markupConfiguration) private var config: MarkupConfiguration
    @EnvironmentObject private var model: MarkupEditorViewModel
    
    private let rearrangeMenu: Menu?
    private let onSelect: (Markup, Int) -> Void
    private let content: Content
    
    @State private var isPhotoPickerOpen: Bool = false
    @State private var isEditing: Bool = true
    @State private var item: PhotosPickerItem?
    @State private var lastOrigin: CGPoint = .zero
    
    // MARK: - Body
    var body: some View {
        
        ZStack {
            Color.black
            
            content
                .overlay {
                    if model.canEditCurrentLayer {
                        MarkupLayerView(layers: model.dirtyLayers, selection: model.currentLayerIndex, onSelect: handleSelection) {
                            if let index = model.currentLayerIndex {
                                SelectionOverlay(currentRotation: $model.dirtyLayers[index].sticker.rotation,
                                                 currentSize: $model.dirtyLayers[index].sticker.size,
                                                 options: config.stickerOptions.contains(.custom) ? .all.subtracting(.edit): .all,
                                                 onUpdate: handleUpdate)
                            }
                        }
                    }
                }
        }
        .gesture(dragGesture)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .photosPicker(isPresented: $isPhotoPickerOpen, selection: $item)
        .overlay(alignment: .top) {
            headerMenu
        }
        .overlay(alignment: .bottom) {
            if config.stickerOptions.contains(.custom) {
                customStickersView
                    .opacity(isEditing ? 1: 0)
            }
        }
        .onChange(of: item) { item in
            if let item {
                loadImage(for: item)
            }
        }
        .onAppear {
            setupLayer()
        }
    }
    
    // MARK: - Initializer
    init(onSelect: @escaping (Markup, Int) -> Void, @ViewBuilder content: () -> Content, @ViewBuilder menu: () -> Menu) {
        self.content = content()
        self.rearrangeMenu = menu()
        self.onSelect = onSelect
    }
    
    init(onSelect: @escaping (Markup, Int) -> Void, @ViewBuilder content: () -> Content) where Menu == EmptyView {
        self.rearrangeMenu = nil
        self.content = content()
        self.onSelect = onSelect
    }
}

// MARK: - Views
extension StickerMarkup {
    
    @ViewBuilder
    private var headerMenu: some View {
        HStack {
            Button {
                discard()
            } label: {
                Image(systemName: "xmark")
            }
            
            Spacer()
            
            if let rearrangeMenu {
                rearrangeMenu
            }
            
            Spacer()
            
            Button {
                save()
            } label: {
                Image(systemName: "checkmark")
            }
        }
        .buttonStyle(.primary)
        .padding(.horizontal, 16)
        .background()
    }
    
    @ViewBuilder
    private var customStickersView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 24) {
                Spacer()
                    .frame(width: 6)
                
                if config.stickerOptions.contains(.gallery) {
                    Button {
                        isPhotoPickerOpen = true
                    } label: {
                        Image(platformImage: PlatformImage(systemName: "photo.badge.plus")!)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.white)
                    }
                }
                
                ForEach(config.customStickers) { sticker in
                    Button {
                        setImage(sticker)
                    } label: {
                        Image(platformImage: sticker)
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                }
                
                Spacer()
                    .frame(width: 6)
            }
        }
        .padding(.top, 12)
        .background(.black.opacity(0.5))
    }
}

// MARK: - Gestures
extension StickerMarkup {
    
    private var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .local)
            .onChanged { value in
                guard let index = model.currentLayerIndex else { return }
                model.dirtyLayers[index].sticker.origin = (lastOrigin + CGPoint(x: value.translation.width, y: value.translation.height))
            }
            .onEnded { _ in
                guard let index = model.currentLayerIndex else { return }
                
                lastOrigin = model.dirtyLayers[index].sticker.origin
            }
    }
}

// MARK: - Methods
extension StickerMarkup {
    
    private func setupLayer() {
        model.setupEditingLayers()
        isEditing = model.currentLayerIndex == nil || config.stickerOptions.contains(.custom)
        
        if model.currentLayerIndex == nil {
            model.currentLayerIndex = model.dirtyLayers.count
            model.dirtyLayers.append(.sticker(.init()))
        }
        lastOrigin = model.dirtyLayers[model.currentLayerIndex!].sticker.origin
        
        isPhotoPickerOpen = isEditing && config.stickerOptions == .gallery
    }
    
    private func loadImage(for item: PhotosPickerItem) {
        Task {
            guard let data = try? await item.loadTransferable(type: Data.self),
                  let image = PlatformImage(data: data)
            else { return }
            
            setImage(image)
        }
    }
    
    private func setImage(_ image: PlatformImage) {
        guard let index = model.currentLayerIndex,
              let cgImage = image.cgImage else { return }
        
        model.dirtyLayers[index].sticker.image = cgImage
    }
    
    private func handleUpdate(for action: SelectionOverlay.Action) {
        switch action {
        case .delete:
            if let index = model.currentLayerIndex {
                model.dirtyLayers.remove(at: index)
                model.currentLayerIndex = nil
                if model.dirtyLayers.count == model.layers.count {
                    model.reset()
                }
            }
        case .edit:
            isEditing = true
            isPhotoPickerOpen = true
        default:
            break
        }
    }
    
    private func handleSelection(markup: Markup, index: Int) {
        onSelect(markup, index)
        lastOrigin = model.dirtyLayers[model.currentLayerIndex!].sticker.origin
    }
    
    private func discard() {
        model.reset()
    }
    
    private func save() {        
        model.commit()
        model.reset()
    }
}
