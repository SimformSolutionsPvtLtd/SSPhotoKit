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
    
    @EnvironmentObject private var model: MarkupEditorViewModel
    
    // MARK: - Vars & Lets
    private let rearrangeMenu: Menu?
    private let content: Content
    
    @State private var frame: CGRect = .zero
    @State private var color: Color = .blue
    @State private var strokeWidth: CGFloat = 10
    @State private var isInitial: Bool = true
    @State private var isEraser: Bool = false
    
    // MARK: - Body
    var body: some View {
        
        ZStack {
            content
                .overlay {
                    MarkupLayerView(layers: model.dirtyLayers)
                }
                .highPriorityGesture(drawGesture)
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
    init(@ViewBuilder content: () -> Content, @ViewBuilder menu: () -> Menu) {
        self.content = content()
        self.rearrangeMenu = menu()
    }
    
    init(@ViewBuilder content: () -> Content) where Menu == EmptyView {
        self.rearrangeMenu = nil
        self.content = content()
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
            
            SSSlider(value: $strokeWidth, in: 1...100)
        }
        .padding(.horizontal, 16)
        .frame(width: bounds.width - 100, height: 80)
        .background(.gray.opacity(0.8))
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
        .background()
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
