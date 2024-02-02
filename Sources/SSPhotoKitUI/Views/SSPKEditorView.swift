//
//  SwiftUIView.swift
//  
//
//  Created by Krunal Patel on 02/01/24.
//

import SwiftUI
import SSPhotoKitEngine

public struct SSPKEditorView: View {
    
    @StateObject var model: SSPKViewModel
    
    public var body: some View {
        ZStack {
            Color.black
            
            editMenuView
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Initializer
    public init(image: CGImage, previewSize: CGSize) {
        _model = StateObject(wrappedValue: SSPKViewModel(image: CIImage(cgImage: image), previewSize: previewSize))
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
                AdjustmentEditor(image: model.engine.previewImage)
            case .filter:
                FilterEditor(image: model.engine.previewImage)
            case .detail:
                EmptyView()//SSMetalView(image: $model.engine.previewImage)
            case .markup:
                EmptyView()//SSMarkupView()
            case .none:
                Image(platformImage: PlatformImage(cgImage: model.engine.previewCGImage))
                    .resizable()
                    .scaledToFit()
                    
            }
        }
        .environmentObject(model)
    }

    @ViewBuilder
    private var headerView: some View {
        HeaderMenu(menuAction: handleMenuAction)
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
    
    private func handleMenuAction(action: MenuAction) {
        switch action {
        case .undo:
            print("Undo")
        case .redo:
            print("Redo")
        case .save:
            print("save")
        case .discard:
            model.engine.reset()
            model.resetEditor()
        }
    }
}
