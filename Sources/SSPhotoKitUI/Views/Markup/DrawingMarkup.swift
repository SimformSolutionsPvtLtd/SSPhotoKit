//
//  DrawingMarkup.swift
//
//
//  Created by Krunal Patel on 05/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct DrawingMarkup<Content, Menu>: View where Content : View, Menu : View {
    
    @Binding var layers: [MarkupLayer]
    @Binding var index: Int?
    let onDiscard: () -> Void
    let onSave: () -> Void
    let rearrangeMenu: Menu?
    @ViewBuilder var content: Content
    
    @State private var color: Color = .blue
    @State private var strokeWidth: CGFloat = 10
    @State private var isInitial: Bool = true
    @State private var isEraser: Bool = false
    
    var body: some View {
        
        VStack {
            Spacer()
            
            content
                .overlay {
                    MarkupLayerView(layers: layers)
                }
                .highPriorityGesture(drawGesture)
                     
            Spacer()
            
            drawingMenu
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .top) {
            headerMenu
        }
        .onAppear {
            if index == nil {
                index = layers.count
                layers.append(.drawing(.init()))
            }
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
            .tint(isEraser ? .blue : .gray)
                
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
                onSave()
            } label: {
                Image(systemName: "checkmark")
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Gestures
extension DrawingMarkup {
    
    private var drawGesture: some Gesture {
        DragGesture(minimumDistance: 1, coordinateSpace: .local)
            .onChanged { drag in
                guard let index else { return }
                
                let newLocation = drag.location
                
                if isInitial {
                    var line = Line(brush: Brush(style: isEraser ? .eraser : .brush, width: strokeWidth, color: color))
                    line.path.append(newLocation)
                    layers[index].drawing.lines.append(line)
                    isInitial = false
                } else if var line = layers[index].drawing.lines.last {
                    line.path.append(newLocation)
                    layers[index].drawing.lines[layers[index].drawing.lines.count - 1] = line
                }
            }
            .onEnded { drag in
                isInitial = true
            }
    }
}
