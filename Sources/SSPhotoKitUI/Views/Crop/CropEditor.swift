//
//  CropEditor.swift
//  SSPhotoKitUI
//
//  Created by Krunal Patel on 03/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct CropEditor: View {
    
    // MARK: - Vars & Lets
    @Environment(\.cropConfiguration) private var config: CropConfiguration
    @EnvironmentObject private var model: EditorViewModel
    @EnvironmentObject private var engine: SSPhotoKitEngine
    
    @StateObject private var cropViewModel = CropEditorViewModel()
    @State private var originalRatio: AspectRatio?
    
    private var ratios: [AspectRatio] {
        var ratios = config.cropRatios
        if config.ratioOptions.contains(.original), let originalRatio {
            ratios.insert(originalRatio, at: 0)
        }
        return ratios
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if let previewImage = engine.previewPlatformImage {
                    ImagePreview(imageSource: .platformImage(previewImage), gesturesEnabled: false)
                        .rotationEffect(.degrees(cropViewModel.rotation))
                        .scaleEffect(cropViewModel.flipScale)
                        .offset(cropViewModel.offset)
                        .scaleEffect(cropViewModel.scale)
                    
                    if cropViewModel.currentEdit == .aspect {
                        CropMask(size: cropViewModel.size)
                    }
                } else {
                    ProgressView()
                }
            }
            .onAppear {
                cropViewModel.frameSize = proxy.size
                if let previewSize = engine.previewPlatformImage?.size {
                    let ratio = AspectRatio(name: "original", height: UInt(previewSize.height), width: UInt(previewSize.width))
                    originalRatio = ratio
                    cropViewModel.currentRatio = ratio
                }
            }
            .overlay(alignment: .bottom) {
                VStack {
                    editTabBar
                    
                    editMenu
                    
                    Divider()
                        .frame(height: 20)
                    
                    FooterMenu("Crop & Rotation") {
                        if let size = engine.previewPlatformImage?.size {
                            Task {
                                await engine.apply(cropViewModel.createCommand(for: size))
                                model.isInitial = true
                                model.resetEditor()
                            }
                        }
                    } onDiscard: {
                        model.resetEditor()
                    }
                }
            }
            .gesture(dragGesture)
            .gesture(magnificationGesture)
        }
    }
}

// MARK: - Views
extension CropEditor {
    
    @ViewBuilder
    private var editTabBar: some View {
        ScrollableTabBar(selection: $cropViewModel.currentEdit, items: Crop.allCases) { edit in
            Text(edit.name)
                .font(.system(size: 16, design: .rounded))
                .foregroundStyle(.white.opacity(cropViewModel.currentEdit == edit ? 1 : 0.6))
        }
    }
    
    @ViewBuilder
    private var editMenu: some View {
        switch cropViewModel.currentEdit {
        case .aspect:
            CropMenu(cropRatios: ratios, isInverted: $cropViewModel.isInverted, currentRatio: $cropViewModel.currentRatio)
        case .rotation:
            RotationMenu(angle: $cropViewModel.rotation,
                         horizontalFlip: $cropViewModel.horizontalFlipped,
                         verticalFlip: $cropViewModel.verticalFlipped)
        case .transform:
            EmptyView()
                .background(.gray)
        }
    }
}

// MARK: - Gestures
extension CropEditor {
    
    private var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .local)
            .onChanged { value in
                cropViewModel.offset = cropViewModel.lastOffset + (value.translation / cropViewModel.scale)
            }
            .onEnded { value in
                cropViewModel.lastOffset = cropViewModel.offset
            }
    }
    
    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                cropViewModel.scale = cropViewModel.lastScale + CGSize(width: value, height: value)
            }
            .onEnded { _ in
                cropViewModel.lastScale = CGSize(width: cropViewModel.scale.width - 1, height: cropViewModel.scale.height - 1)
            }
    }
}

// MARK: - Methods
extension CropEditor {
    
    private func handleMenuAction(action: MenuAction) {
        switch action {
        case .undo:
            print("undo")
        case .redo:
            print("redo")
        case .save:
            if let size = engine.previewPlatformImage?.size {
                Task {
                    await engine.apply(cropViewModel.createCommand(for: size))
                    model.resetEditor()
                }
            }
        case .discard:
            model.resetEditor()
        }
    }
}
