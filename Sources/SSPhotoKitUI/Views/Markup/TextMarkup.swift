//
//  TextMarkup.swift
//  
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct TextMarkup<Content, Menu>: View where Content : View, Menu : View {
    
    @Binding var layers: [MarkupLayer]
    @Binding var index: Int?
    let onDiscard: () -> Void
    let onSave: () -> Void
    let rearrangeMenu: Menu?
    @ViewBuilder var content: Content
    
    @State private var text: String = ""
    @State private var showFonts: Bool = false
    @FocusState private var isFocused: Bool
    @State private var lastOrigin: CGPoint = .zero
    
    var body: some View {
        
        ZStack {
            
            content
                .overlay {
                    if let index {
                        MarkupLayerView(layers: layers, selection: index) {
                            SelectionOverlay(currentRotation: $layers[index].text.rotation,
                                             currentSize: $layers[index].text.size,
                                             keepAspectRatio: false,
                                             onUpdate: handleUpdate)
                        }
                    }
                }
            
            VStack {
                Spacer()
                if showFonts {
                    fontSelector
                }
                
                Button {
                    showFonts.toggle()
                } label: {
                    Image(systemName: "a.square")
                }
                .foregroundStyle(.white)
            }
            
            textEditor
        }
        .gesture(dragGesture)
        .overlay(alignment: .top) {
            headerMenu
        }
        .onAppear {
            isFocused = index == nil
            
            if let index {
                text = layers[index].text.text
            } else {
                index = layers.count
                layers.append(.text(.init()))
            }
            lastOrigin = layers[index!].text.origin
        }
    }
    
    // MARK: - Initializer
    init(layers: Binding<[MarkupLayer]>, index: Binding<Int?>, onSave: @escaping () -> Void, onDiscard: @escaping () -> Void, @ViewBuilder content: () -> Content, @ViewBuilder menu: () -> Menu) {
        self._layers = layers
        self._index = index
        self.onSave = onSave
        self.onDiscard = onDiscard
        self.content = content()
        self.rearrangeMenu = menu()
    }
    
    init(layers: Binding<[MarkupLayer]>, index: Binding<Int?>, onSave: @escaping () -> Void, onDiscard: @escaping () -> Void, @ViewBuilder content: () -> Content) where Menu == EmptyView {
        self._layers = layers
        self._index = index
        self.onSave = onSave
        self.onDiscard = onDiscard
        self.rearrangeMenu = nil
        self.content = content()
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
            .focused($isFocused)
            .multilineTextAlignment(.center)
            .onSubmit {
                isFocused = false
                updateText()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.8))
        .opacity(isFocused ? 1 : 0)
    }
    
    @ViewBuilder
    private var headerMenu: some View {
        HStack {
            Button {
                onDiscard()
            } label: {
                Image(systemName: "xmark")
            }
            
            Spacer()
            
            if let rearrangeMenu {
                rearrangeMenu
            }
            
            Spacer()
            
            Button {
                if isFocused {
                    updateText()
                } else {
                    onSave()
                }
            } label: {
                Image(systemName: "checkmark")
            }
        }
        .padding(.horizontal, 16)
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
                                if let index {
                                    layers[index].text.fontName = font
                                }
                            }
                    }
                }
            }
        }
        .frame(height: 200)
    }
}

// MARK: - Gestures
extension TextMarkup {
    
    private var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged { value in
                guard let index else { return }
                
                layers[index].text.origin = lastOrigin + CGPoint(x: value.translation.width, y: value.translation.height)
            }
            .onEnded { value in
                guard let index else { return }
                
                lastOrigin = layers[index].text.origin
            }
    }
}

// MARK: - Methods
extension TextMarkup {

    private func updateText() {
        if let index {
            layers[index].text.text = text
        }
        isFocused = false
    }
    
    private func handleUpdate(for action: SelectionAction) {
        switch action {
        case .delete:
            if let index {
                layers.remove(at: index)
            }
            index = nil
        case .edit:
            isFocused = true
        default:
            break
        }
    }
}
