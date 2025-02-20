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
    @Environment(\.editorConfiguration) var editorConfig: EditorConfiguration
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
                        .scaleEffect(cropViewModel.scale, anchor: .center)
                    
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
                    cropViewModel.imageSize = previewSize
                    cropViewModel.resizeAndCenterImage(shouldScale: true)
                }
            }
            .overlay(alignment: .bottom) {
                VStack {
                    editTabBar
                    
                    editMenu
                    
                    Divider()
                        .frame(height: 20)
                    
                    FooterMenu("Crop & Rotation") {
                        if let originalSize = engine.originalPreviewImage?.size,
                            let newSize = engine.previewPlatformImage?.size {
                            Task {
                                await engine.apply(cropViewModel.createCommand(for: originalSize, with: newSize))
                                model.isInitial = true
                                model.resetEditor()
                            }
                        }
                    } onDiscard: {
                        model.resetEditor()
                    }
                }
                .background(editorConfig.theme.menuBackground.opacity(0.6))
                .foregroundStyle(editorConfig.theme.menuForeground)
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
                .foregroundStyle(editorConfig.theme.menuForeground.opacity(cropViewModel.currentEdit == edit ? 1 : 0.6))
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
                // Calculation - ((image size - frame size / scale) / 2) - abs(offset) > 0
                var centerOffset = cropViewModel.lastOffset + (value.translation / cropViewModel.scale)
                let imageSize = engine.previewPlatformImage!.size
                let scaledFrameSize = cropViewModel.size / cropViewModel.scale
                let availableOffset = (imageSize - scaledFrameSize) / CGSize(width: 2, height: 2)
                
                // Clamp the offset to ensure it stays within bounds
                centerOffset.width = min(max(centerOffset.width, -availableOffset.width), availableOffset.width)
                centerOffset.height = min(max(centerOffset.height, -availableOffset.height), availableOffset.height)
              
                cropViewModel.offset = centerOffset
            }
            .onEnded { _ in
                cropViewModel.lastOffset = cropViewModel.offset
            }
    }
    
    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let newScale = CGSize(width: value - 1, height: value - 1) * cropViewModel.lastScale
                cropViewModel.scale = cropViewModel.lastScale + newScale
            }
            .onEnded { _ in
                cropViewModel.lastScale = CGSize(width: cropViewModel.scale.width, height: cropViewModel.scale.height)
                adjustScale()
                adjustOffset()
            }
    }
}

// MARK: - Methods
extension CropEditor {
    
    /// Adjusts the scale of the crop view. If the scaled frame size exceeds
    /// the original image width, the scale is reset to 1.0 to fit the image properly.
    ///
    /// This method ensures the crop frame does not exceed the image size, which
    /// could lead to undesired scaling artifacts.
    private func adjustScale() {
        let scaledFrameSize = cropViewModel.size / cropViewModel.scale
        
        // Check if the scaled frame size exceeds the original image size.
        if scaledFrameSize.width > engine.previewPlatformImage!.size.width {
            withAnimation {
                cropViewModel.scale = .one
                cropViewModel.lastScale = .one
            }
        }
    }
    
    /// Adjusts the crop view's offset to ensure it remains within the bounds of the image.
    ///
    /// This method calculates the maximum available offset based on the image and scaled
    /// frame size, and clamps the offset to prevent the crop area from moving outside the image.
    private func adjustOffset() {
        var centerOffset = cropViewModel.lastOffset
        let imageSize = engine.previewPlatformImage!.size
        let scaledFrameSize = cropViewModel.size / cropViewModel.scale
        let availableOffset = (imageSize - scaledFrameSize) / CGSize(width: 2, height: 2)
        
        // Clamp the offset to ensure it stays within bounds
        centerOffset.width = min(max(centerOffset.width, -availableOffset.width), availableOffset.width)
        centerOffset.height = min(max(centerOffset.height, -availableOffset.height), availableOffset.height)
        
        // Animate the adjustment of the offset
        withAnimation {
            cropViewModel.offset = centerOffset
            cropViewModel.lastOffset = centerOffset
        }
    }
}
