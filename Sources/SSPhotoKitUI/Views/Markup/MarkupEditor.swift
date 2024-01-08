//
//  MarkupEditor.swift
//
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct MarkupEditor: View {
    
    @EnvironmentObject var model: SSPKViewModel
    @StateObject var markupViewModel = MarkupEditorViewModel()
    
    private var previewSize: CGSize {
        model.engine.previewImage.extent.size
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            
            markupView
            
            Spacer()
            
            if markupViewModel.currentMarkup == .none {
                markupMenu
                
                Divider()
                    .frame(height: 20)
                
                FooterMenu(markupViewModel.currentMarkup.description) {
                    Task {
                        let command = markupViewModel.createCommand { layers in
                            MarkupLayerView(layers: layers)
                        }
                        await model.engine.apply(command)
                        model.resetEditor()
                    }
                } onDiscard: {
                    model.resetEditor()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
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
            .disabled(!markupViewModel.canArrange(.moveDown))
            
            Button {
                markupViewModel.arrange(.moveUp)
            } label: {
                 Image(systemName: "arrow.up.to.line")
            }
            .disabled(!markupViewModel.canArrange(.moveUp))
        }
    }
    
    @ViewBuilder
    private var markupView: some View {
        switch markupViewModel.currentMarkup {
        case .drawing:
            DrawingMarkup(layers: $markupViewModel.dirtyLayers,
                          index: $markupViewModel.currentLayerIndex,
                          onSave: handleMarkupSave,
                          onDiscard: handleMarkupDiscard) {
                Image(platformImage: PlatformImage(cgImage: model.engine.previewCGImage))
            } menu: {
                rearrangeMenu
            }
            
        case .text:
            TextMarkup(layers: $markupViewModel.dirtyLayers,
                       index: $markupViewModel.currentLayerIndex,
                       onSave: handleMarkupSave,
                       onDiscard: handleMarkupDiscard) {
                Image(platformImage: PlatformImage(cgImage: model.engine.previewCGImage))
            } menu: {
                rearrangeMenu
            }
            
        case .sticker:
            StickerMarkup(layers: $markupViewModel.dirtyLayers,
                          index: $markupViewModel.currentLayerIndex,
                          onSave: handleMarkupSave,
                          onDiscard: handleMarkupDiscard) {
                Image(platformImage: PlatformImage(cgImage: model.engine.previewCGImage))
            } menu: {
                rearrangeMenu
            }
            
        case .none:
            Image(platformImage: PlatformImage(cgImage: model.engine.previewCGImage))
                .overlay {
                    MarkupLayerView(layers: markupViewModel.layers, onSelect: handleSelection)
                }
        }
    }
    
    @ViewBuilder
    private var markupMenu: some View {
        ScrollableTabBar(selection: $markupViewModel.currentMarkup, items: Markup.allCases.filter { $0 != .none}) { item in
            VStack(spacing: 6) {
                Image(systemName: item.icon)
                    .font(.system(size: 26, design: .rounded))
                    .foregroundStyle(.white.opacity(markupViewModel.currentMarkup == item ? 1 : 0.6))
                
                Circle()
                    .fill(.white)
                    .frame(height: markupViewModel.currentMarkup == item ? 6 : 0)
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
        markupViewModel.currentMarkup = markup
        markupViewModel.currentLayerIndex = position
    }
}
