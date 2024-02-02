//
//  SwiftUIView.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//

import SwiftUI
import SSPhotoKitEngine

public struct SSPKEditorView: View {
    
    @StateObject var model = EditorViewModel()
    @StateObject var engine: SSPhotoKitEngine
    
    public var body: some View {
        ZStack {
            Color.black
            
            editMenuView
        }
        .preferredColorScheme(.dark)
        .environmentObject(model)
        .environmentObject(engine)
    }
    
    // MARK: - Initializer
    public init(image: CGImage, previewSize: CGSize) {
        _engine = StateObject(wrappedValue: SSPhotoKitEngine(image: CIImage(cgImage: image), previewSize: previewSize))
    }
}

// MARK: - Views
extension SSPKEditorView {
    
    @ViewBuilder
    private var editMenuView: some View {
        
        VStack {
            if model.currentEditor == .none {
                headerView
            }
            
            previewView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if model.shouldShowTabBar {
                tabBarView
            }
        }
    }
    
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
                Image(platformImage: PlatformImage(cgImage: engine.previewCGImage))
                    .resizable()
                    .scaledToFit()
            }
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        HeaderMenu(disableOptions: getHeaderDisableOptions(),
                   menuAction: handleMenuAction)
    }
    
    @ViewBuilder
    private var tabBarView: some View {
        ScrollableTabBar(selection: $model.currentEditor, items: model.editors) { item in
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
        .opacity(model.shouldShowTabBar ? 1 : 0)
        .animation(.easeInOut, value: model.shouldShowTabBar)
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
        
        if !engine.canDiscard {
            options.insert(.discard)
        }
        
        return options
    }
    
    private func handleMenuAction(action: MenuAction) {
        Task {
            switch action {
            case .undo:
                await engine.undo()
            case .redo:
                await engine.redo()
            case .save:
                let image = await engine.createImage()
                print(image)
                
            case .discard:
                engine.reset()
                model.resetEditor()
            }
        }
    }
}
