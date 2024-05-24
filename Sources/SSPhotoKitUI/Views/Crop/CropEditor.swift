//
//  CropEditor.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 03/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

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
                    Image(platformImage: previewImage)
                        .scaleEffect(cropViewModel.flipScale)
                        .rotationEffect(.degrees(cropViewModel.rotation))
                        .offset(cropViewModel.offset)
                        .scaleEffect(cropViewModel.scale)
                    
                    CropMask(size: cropViewModel.size)
                } else {
                    ProgressView()
                }
            }
            .clipped()
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
                        if let newSize = engine.previewPlatformImage?.size {
                            Task {
                                await engine.apply(cropViewModel.createCommand(for: engine.originalPreviewImage.size, with: newSize))
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
        ScrollableTabBar(selection: $cropViewModel.currentEdit, items: Crop.getAllowedCrops(with: config.allowedCrops)) { edit in
            Text(edit.name)
                .font(.system(size: 16, design: .rounded))
                .foregroundStyle(.white.opacity(cropViewModel.currentEdit == edit ? 1: 0.6))
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
        DragGesture(coordinateSpace: .global)
            .onChanged { value in
                // Calculation - ((image size - frame size / scale) / 2) - abs(offset) > 0
                var centerOffset = cropViewModel.lastOffset + (value.translation / cropViewModel.scale)
                let imageSize = engine.previewPlatformImage!.size
                let scaledFrameSize = cropViewModel.size / cropViewModel.scale
                let availableOffset = (imageSize - scaledFrameSize) / CGSize(width: 2, height: 2)
                
                if availableOffset.width - abs(centerOffset.width) < 0 {
                    centerOffset.width = cropViewModel.offset.width
                }
                
                if availableOffset.height - abs(centerOffset.height) < 0 {
                    centerOffset.height = cropViewModel.offset.height
                }
                cropViewModel.offset = centerOffset
            }
            .onEnded { _ in
                cropViewModel.lastOffset = cropViewModel.offset
            }
    }
    
    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let scale = cropViewModel.lastScale + CGSize(width: value, height: value)
                // No validation need when zooming in
                if value > 1 {
                    cropViewModel.scale = scale
                    return
                }
                
                // Validate scaled image boundaries
                let imageOffset = cropViewModel.lastOffset
                let imageSize = engine.previewPlatformImage!.size
                let scaledFrameSize = cropViewModel.size / scale
                let availableOffset = (imageSize - scaledFrameSize) / CGSize(width: 2, height: 2)
                guard availableOffset.width - abs(imageOffset.width) >= 0 ||
                    availableOffset.height - abs(imageOffset.height) >= 0 else {
                    return
                }
                
                cropViewModel.scale = scale
            }
            .onEnded { _ in
                cropViewModel.lastScale = CGSize(width: cropViewModel.scale.width - 1, height: cropViewModel.scale.height - 1)
            }
    }
}
