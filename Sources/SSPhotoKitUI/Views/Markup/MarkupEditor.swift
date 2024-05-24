//
//  MarkupEditor.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

struct MarkupEditor: View {
    
    // MARK: - Vars & Lets
    @Environment(\.markupConfiguration) private var config: MarkupConfiguration
    @EnvironmentObject var model: EditorViewModel
    @EnvironmentObject var engine: SSPhotoKitEngine
    @StateObject var markupViewModel = MarkupEditorViewModel()
    
    @State private var isInitial = true
    private var isMarkupEditor: Bool { markupViewModel.currentMarkup != .none }

    // MARK: - Body
    var body: some View {
        ZStack {
            markupView
        }
        .environmentObject(markupViewModel)
        .overlay(alignment: .bottom) {
            if !isMarkupEditor {
                footerMenu
            }
        }
        .onAppear {
            markupViewModel.containerSize = model.previewFrame.size
        }
        .onPreferenceChange(PreviewOffsetPreference.self) { value in
            markupViewModel.offset = value
        }
        .onPreferenceChange(PreviewScalePreference.self) { value in
            markupViewModel.scale = value
        }
    }
}

// MARK: - Views
extension MarkupEditor {
    
    @ViewBuilder
    private var rearrangeMenu: some View {
        HStack(spacing: 20) {
            Button {
                markupViewModel.arrange(.moveDown)
            } label: {
                Image(systemName: "arrow.down.to.line")
            }
            .foregroundStyle(markupViewModel.canArrange(.moveDown) ? .blue: .gray)
            .disabled(!markupViewModel.canArrange(.moveDown))
            
            Button {
                markupViewModel.arrange(.moveUp)
            } label: {
                Image(systemName: "arrow.up.to.line")
            }
            .foregroundStyle(markupViewModel.canArrange(.moveUp) ? .blue: .gray)
            .disabled(!markupViewModel.canArrange(.moveUp))
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }
    
    @ViewBuilder
    private var footerMenu: some View {
        VStack {
            markupMenu
                .environmentObject(markupViewModel)
                .padding(.top, 8)
            
            Divider()
            
            FooterMenu(markupViewModel.currentMarkup.description,
                       disableOptions: getFooterDisableOptions()) {
                Task {
                    let command = markupViewModel.createCommand { layers in
                        MarkupLayerView(layers: layers)
                    }
                    await engine.apply(command)
                    model.resetEditor()
                }
            } onDiscard: {
                model.resetEditor()
            }
        }
        .background()
    }
    
    @ViewBuilder
    private var markupView: some View {
        switch markupViewModel.currentMarkup {
        case .drawing:
            DrawingMarkup(onSelect: handleSelection(for:at:)) {
                imagePreview
            } menu: {
                rearrangeMenu
            }
            
        case .text:
            TextMarkup(onSelect: handleSelection(for:at:)) {
                imagePreview
            } menu: {
                rearrangeMenu
            }
            
        case .sticker:
            StickerMarkup(onSelect: handleSelection(for:at:)) {
                imagePreview
            } menu: {
                rearrangeMenu
            }
        case .none:
            imagePreview
        }
    }
    
    @ViewBuilder
    private var imagePreview: some View {
        if let previewImage = engine.previewPlatformImage {
            ImagePreview(imageSource: .platformImage(previewImage),
                         gesturesEnabled: !isMarkupEditor) {
                if !isMarkupEditor {
                    MarkupLayerView(layers: markupViewModel.layers, onSelect: handleSelection)
                }
            }.onAppear {
                isInitial = false
            }
        } else {
            ProgressView()
            
        }
    }
    
    @ViewBuilder
    private var markupMenu: some View {
        ScrollableTabBar(selection: $markupViewModel.currentMarkup, items: Markup.getAllowedMarkups(with: config.allowedMarkups)) { item in
            VStack(spacing: 6) {
                Image(systemName: item.icon)
                    .font(.system(size: 26, design: .rounded))
                    .foregroundStyle(.white.opacity(markupViewModel.currentMarkup == item ? 1: 0.6))
                
                Circle()
                    .fill(.white)
                    .frame(height: markupViewModel.currentMarkup == item ? 6: 0)
            }
        }
        .onItemReselect { _ in
            markupViewModel.currentMarkup = .none
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Methods
extension MarkupEditor {
    
    private func handleMarkupSave() {
        markupViewModel.commit()
        markupViewModel.reset()
    }
    
    private func handleMarkupDiscard() {
        markupViewModel.reset()
    }
    
    private func handleSelection(for markup: Markup, at position: Int) {
        markupViewModel.currentLayerIndex = position
        markupViewModel.currentMarkup = markup
    }
    
    private func getFooterDisableOptions() -> FooterMenu.DisableOption {
        var options: FooterMenu.DisableOption = []
        
        if markupViewModel.layers.isEmpty {
            options.insert(.save)
        }
        
        return options
    }
}
