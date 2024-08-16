//
//  DrawingMarkup.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 05/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

struct DrawingMarkup<Content, Menu>: View where Content: View, Menu: View {
    
    // MARK: - Vars & Lets
    @Environment(\.editorConfiguration) private var editorConfig: EditorConfiguration
    @EnvironmentObject private var model: MarkupEditorViewModel
    
    private let rearrangeMenu: Menu?
    private let onSelect: (Markup, Int) -> Void
    private let content: Content
    
    @State private var frame: CGRect = .zero
    @State private var color: Color = .blue
    @State private var strokeWidth: CGFloat = 10
    @State private var isInitial: Bool = true
    @State private var isEraser: Bool = false
    @State private var isStrokeVisible: Bool = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            content
                .overlay {
                    MarkupLayerView(layers: model.dirtyLayers, onSelect: onSelect)
                }
                .highPriorityGesture(drawGesture)
            
            if isStrokeVisible {
                Circle()
                    .fill()
                    .frame(width: strokeWidth, height: strokeWidth)
                    .background(color.opacity(0.8))
                    .clipShape(.circle)
                    .overlay(alignment: .topTrailing) {
                        Image(systemName: isEraser ? "eraser.fill" : "pencil")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .offset(x: 20, y: -20)
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .top) {
            headerMenu
        }
        .overlay(alignment: .bottom) {
            drawingMenu
        }
        .onAppear {
            model.setupEditingLayers()
            if model.currentLayerIndex == nil {
                model.currentLayerIndex = model.dirtyLayers.count
                model.dirtyLayers.append(.drawing(.init()))
            }
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
extension DrawingMarkup {
    
    @ViewBuilder
    private var drawingMenu: some View {
        HStack {
            ColorPicker(selection: $color) { }
                .labelsHidden()
            
            Button {
                isEraser.toggle()
            } label: {
                Image(systemName: "eraser.fill")
            }
            .buttonStyle(.borderedProminent)
            .tint(isEraser ? .blue: .gray)
            
            SSSlider(value: $strokeWidth, in: 1...100) { isEditing in
                isStrokeVisible = isEditing
            }
        }
        .padding(.horizontal, 16)
        .frame(width: bounds.width - 100, height: 80)
        .background(editorConfig.theme.menuBackground.opacity(0.6))
        .foregroundStyle(editorConfig.theme.menuForeground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
                save()
            } label: {
                Image(systemName: "checkmark")
            }
        }
        .buttonStyle(.primary)
        .padding(.horizontal, 16)
        .background(editorConfig.theme.menuBackground)
        .foregroundStyle(editorConfig.theme.menuForeground)
    }
}

// MARK: - Gestures
extension DrawingMarkup {
    
    private var drawGesture: some Gesture {
        DragGesture(minimumDistance: 1, coordinateSpace: .local)
            .onChanged { drag in
                guard let index = model.currentLayerIndex else { return }
                let newLocation = drag.location // - frame.origin
                
                if isInitial {
                    var line = Line(brush: Brush(style: isEraser ? .eraser: .brush, width: strokeWidth, color: color))
                    line.path.append(newLocation)
                    model.dirtyLayers[index].drawing.lines.append(line)
                    isInitial = false
                } else if var line = model.dirtyLayers[index].drawing.lines.last {
                    line.path.append(newLocation)
                    model.dirtyLayers[index].drawing.lines[model.dirtyLayers[index].drawing.lines.count - 1] = line
                }
            }
            .onEnded { _ in
                isInitial = true
            }
    }
    
    private func discard() {
        model.reset()
    }
    
    private func save() {
        model.commit()
        model.reset()
    }
}
