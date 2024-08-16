//
//  TextMarkup.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

struct TextMarkup<Content, Menu>: View where Content: View, Menu: View {
    
    // MARK: - Vars & Lets
    @Environment(\.editorConfiguration) private var editorConfig: EditorConfiguration
    @EnvironmentObject private var model: MarkupEditorViewModel
    
    private let rearrangeMenu: Menu?
    private let onSelect: (Markup, Int) -> Void
    private let content: Content
    
    @State private var text: String = ""
    @State private var showFonts: Bool = false
    @FocusState private var isFocused: Bool
    @State private var lastOrigin: CGPoint = .zero
    @State private var currentFontName = "ChalkboardSE-Regular"
    @State private var currentColor: Color = .white
    @State private var editorBackground: Color = .black
    
    // MARK: - Body
    var body: some View {
        
        ZStack {
            Color.black
            
            content
                .overlay {
                    if model.canEditCurrentLayer {
                        MarkupLayerView(layers: model.dirtyLayers, selection: model.currentLayerIndex, onSelect: handleSelection) {
                            if let index = model.currentLayerIndex {
                                SelectionOverlay(currentRotation: $model.dirtyLayers[index].text.rotation,
                                                 currentSize: $model.dirtyLayers[index].text.size, onUpdate: handleUpdate)
                            }
                        }
                    }
                }
            textEditor
        }
        .gesture(dragGesture)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .top) {
            headerMenu
        }
        .overlay(alignment: .bottom) {
            footerMenu
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
extension TextMarkup {
    
    @ViewBuilder
    private var textEditor: some View {
        ZStack {
            TextField(text: $text) {
                Text("Type something")
            }
            .font(.custom(currentFontName, size: 18))
            .foregroundStyle(.white)
            .colorMultiply(currentColor)
            .focused($isFocused)
            .multilineTextAlignment(.center)
            .onSubmit {
                isFocused = false
                updateText()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(editorBackground.opacity(0.8))
        .opacity(isFocused ? 1: 0)
    }
    
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
                isFocused ? updateText(): save()
            } label: {
                Image(systemName: "checkmark")
            }
        }
        .buttonStyle(.primary)
        .padding(.horizontal, 16)
        .background(editorConfig.theme.menuBackground)
        .foregroundStyle(editorConfig.theme.menuForeground)
    }
    
    @ViewBuilder
    private var footerMenu: some View {
        VStack {
            if showFonts {
                fontSelector
            }
            
            HStack(spacing: 44) {
                Button {
                    showFonts.toggle()
                } label: {
                    Image(systemName: "a.square")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.white)
                
                if let index = model.currentLayerIndex,
                   model.canEditCurrentLayer {
                    ColorPicker("", selection: $currentColor)
                        .labelsHidden()
                        .onChange(of: currentColor) { value in
                            $model.dirtyLayers[index].text.color.wrappedValue = value
                            withAnimation {
                                editorBackground = getContrastingBackgroundColor(for: value)
                            }
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 56)
        .background(editorConfig.theme.menuBackground.opacity(0.6))
        .foregroundStyle(editorConfig.theme.menuForeground)
    }
    
    @ViewBuilder
    private var fontSelector: some View {
        
        List {
            ForEach(FontHelper.fontFamilies, id: \.self) { family in
                Section(header: Text(family)) {
                    
                    ForEach(FontHelper.fonts(for: family), id: \.self) { font in
                        Text(font)
                            .font(.custom(font, size: 16))
                            .onTapGesture {
                                showFonts = false
                                if let index = model.currentLayerIndex {
                                    model.dirtyLayers[index].text.fontName = font
                                    currentFontName = font
                                }
                            }
                    }
                }
            }
        }
        .frame(height: 200)
        .contentShape(.rect)
    }
}

// MARK: - Gestures
extension TextMarkup {
    
    private var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged { value in
                guard let index = model.currentLayerIndex else { return }
                
                model.dirtyLayers[index].text.origin = lastOrigin + value.translation.toCGPoint()
            }
            .onEnded { _ in
                guard let index = model.currentLayerIndex else { return }
                
                lastOrigin = model.dirtyLayers[index].text.origin
            }
    }
}

// MARK: - Methods
extension TextMarkup {
    
    private func setupLayer() {
        model.setupEditingLayers()
        isFocused = model.currentLayerIndex == nil
        
        if let index = model.currentLayerIndex {
            text = model.dirtyLayers[index].text.text
        } else {
            model.currentLayerIndex = model.dirtyLayers.count
            model.dirtyLayers.append(.text(.init()))
        }
        
        lastOrigin = model.dirtyLayers[model.currentLayerIndex!].text.origin
    }
    
    private func updateText() {
        if let index = model.currentLayerIndex {
            model.dirtyLayers[index].text.text = text
        }
        isFocused = false
    }
    
    private func handleUpdate(for action: SelectionOverlay.Action) {
        switch action {
        case .delete:
            if let index = model.currentLayerIndex {
                model.dirtyLayers.remove(at: index)
            }
            model.currentLayerIndex = nil
        case .edit:
            isFocused = true
        default:
            break
        }
    }
    
    private func handleSelection(markup: Markup, index: Int) {
        onSelect(markup, index)
        lastOrigin = model.dirtyLayers[model.currentLayerIndex!].text.origin
    }
    
    private func discard() {
        model.reset()
    }
    
    private func save() {
        model.commit()
        model.reset()
    }
    
    private func getContrastingBackgroundColor(for textColor: Color) -> Color {
        let uiColor = UIColor(textColor)
        var white: CGFloat = 0
        uiColor.getWhite(&white, alpha: nil)
        
        // If the text color is dark, use a light background; otherwise, use a dark background.
        return white < 0.5 ? .white : .black
    }
}
