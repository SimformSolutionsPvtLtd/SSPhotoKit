//
//  CropEditor.swift
//
//
//  Created by Krunal Patel on 03/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct CropEditor: View {
    
    // MARK: - Vars & Lets
    @EnvironmentObject var model: SSPKViewModel
    @StateObject var cropViewModel = CropEditorViewModel()
    
    // MARK: - Body
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black
                
                Image(platformImage: model.engine.previewPlatformImage)
                    .rotationEffect(.degrees(cropViewModel.rotation))
                    .scaleEffect(cropViewModel.flipScale)
                    .offset(cropViewModel.offset)
                    .scaleEffect(cropViewModel.scale)
                
                CropMask(size: cropViewModel.size)
            }
            .onAppear {
                cropViewModel.frameSize = proxy.size
                cropViewModel.updateSize()
            }
            .overlay(alignment: .bottom) {
                VStack {
                    editTabBar
                    
                    editMenu(proxy: proxy)
                        .frame(height: 60)
                    
                    Divider()
                        .frame(height: 20)
                    
                    FooterMenu("Crop & Rotation") {
                        Task {
                            await model.engine.apply(cropViewModel.createCommand(for: model.engine.previewCGImage.size))
                            model.resetEditor()
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
    private func editMenu(proxy: GeometryProxy) -> some View {
        switch cropViewModel.currentEdit {
        case .aspect:
            CropMenu(isInverted: $cropViewModel.isInverted, currentRatio: $cropViewModel.cropRatio)
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
            Task {
                await model.engine.apply(cropViewModel.createCommand(for: model.engine.previewCGImage.size))
                model.resetEditor()
            }
        case .discard:
            model.resetEditor()
        }
    }
}
