//
//  SSPKEditorView.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//

import SwiftUI
import SSPhotoKitEngine

public struct SSPKEditorView: View {
    
    // MARK: - Vars & Lets
    @Environment(\.editorConfiguration) var config: EditorConfiguration
    @Binding var image: PlatformImage
    @Binding var isPresented: Bool
    @StateObject var engine: SSPhotoKitEngine
    @StateObject var model = EditorViewModel()
    @State private var showingConfirmation = false
    
    // MARK: - Body
    public var body: some View {
        ZStack {
            Color.black
            
            previewView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if model.isLoading {
                Color.black.opacity(0.4)
                ProgressView()
            }
        }
        .overlay(alignment: .top) {
            if model.currentEditor == .none {
                headerView
            }
        }
        .overlay(alignment: .bottom) {
            if model.shouldShowTabBar {
                tabBarView
            }
        }
        .confirmationDialog(engine.canDiscard ? "Discard changes" : "Close Editor",
                            isPresented: $showingConfirmation) {
            discardDialog
        }
                            .preferredColorScheme(.dark)
                            .environmentObject(model)
                            .environmentObject(engine)
    }
    
    // MARK: - Initializer
    public init(image: Binding<PlatformImage>, isPresented: Binding<Bool>, previewSize: CGSize) {
        _image = image
        _isPresented = isPresented
        _engine = StateObject(wrappedValue: SSPhotoKitEngine(image: CIImage(cgImage: image.wrappedValue.cgImage!), previewSize: previewSize))
    }
}

// MARK: - Views
extension SSPKEditorView {
    
    @ViewBuilder
    private var previewView: some View {
        ZStack {
            switch model.currentEditor {
            case .crop:
                CropEditor()
            case .adjustment:
                AdjustmentEditor(image: engine.previewImage)
            case .filter:
                FilterEditor(image: engine.previewImage)
            case .detail:
                DetailEditor(image: engine.previewImage)
            case .markup:
                MarkupEditor()
            case .none:
                if let previewImage = engine.previewPlatformImage {
                    ImagePreview(imageSource: .platformImage(previewImage), centerOptions: [.initial, .imageSizeChange, .frameSizeChange])
                } else {
                    ProgressView()
                }
            }
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        HeaderMenu(disableOptions: getHeaderDisableOptions(),
                   menuAction: handleMenuAction)
        .background()
    }
    
    @ViewBuilder
    private var tabBarView: some View {
        ScrollableTabBar(selection: $model.currentEditor, items: Editor.getAllowedEditors(with: config.allowedEditors)) { item in
            VStack(spacing: 6) {
                Image(systemName: item.icon)
                    .font(.system(size: 26, design: .rounded))
                    .foregroundStyle(.white.opacity(model.currentEditor == item ? 1 : 0.6))
                
                Circle()
                    .fill(.white)
                    .frame(height: model.currentEditor == item ? 6 : 0)
            }
        }
        .onItemReselect { _ in
            model.resetEditor()
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background()
        .opacity(model.shouldShowTabBar ? 1 : 0)
        .animation(.easeInOut, value: model.shouldShowTabBar)
    }
    
    @ViewBuilder
    private var discardDialog: some View {
        Button(engine.canDiscard ? "Discard changes" : "Close Editor", role: .destructive) {
            if engine.canDiscard {
                engine.reset()
                model.resetEditor()
            } else {
                isPresented = false
            }
        }
        
        Button("Cancel", role: .cancel) {
            showingConfirmation = false
        }
    }
}

// MARK: - Methods
extension SSPKEditorView {
    
    private func getHeaderDisableOptions() -> HeaderMenu.DisableOptions {
        
        var options: HeaderMenu.DisableOptions = []
        
        if !engine.canUndo {
            options.insert(.undo)
        }
        
        if !engine.canRedo {
            options.insert(.redo)
        }
        
        if !engine.canSave {
            options.insert(.save)
        }
        
        return options
    }
    
    private func handleMenuAction(action: MenuAction) {
        Task {
            model.isLoading = true
            switch action {
            case .undo:
                await engine.undo()
            case .redo:
                await engine.redo()
            case .save:
                if let platformImage = await engine.createPlatformImage() {
                    image = platformImage
                }
                isPresented = false
            case .discard:
                showingConfirmation = true
            }
            model.isLoading = false
        }
    }
}
