//
//  MarkupLayerView.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

struct MarkupLayerView<Overlay: View>: View {
    
    // MARK: - Vars & Lets
    private let layers: [MarkupLayer]
    private let selection: Int?
    private let selectionOverlay: Overlay?
    private let onSelect: ((Markup, Int) -> Void)?
    
    // MARK: - Body
    var body: some View {
        ZStack {
            ForEach(layers.indices, id: \.self) { index in
                let layer = layers[index]
                switch layer {
                case .text(let textMarkupItem):
                    getTextView(textMarkupItem, isSelected: selection == index)
                        .onTapGesture {
                            onSelect?(.text, index)
                        }
                case .drawing(let drawingMarkupItem):
                    getDrawingView(drawingMarkupItem)
                        .onTapGesture {
                            onSelect?(.drawing, index)
                        }
                case .sticker(let stickerMarkupItem):
                    getStickerView(stickerMarkupItem, isSelected: selection == index)
                        .onTapGesture {
                            onSelect?(.sticker, index)
                        }
                }
            }
        }
    }
    
    // MARK: - Initializer
    init(layers: [MarkupLayer], selection: Int? = nil, onSelect: ((Markup, Int) -> Void)? = nil, @ViewBuilder overlay: @escaping (() -> Overlay)) {
        self.layers = layers
        self.selection = selection
        self.selectionOverlay = overlay()
        self.onSelect = onSelect
    }
    
    init(layers: [MarkupLayer], selection: Int? = nil, onSelect: ((Markup, Int) -> Void)? = nil) where Overlay == EmptyView {
        self.layers = layers
        self.selection = selection
        self.selectionOverlay = nil
        self.onSelect = onSelect
    }
}

// MARK: - Views
extension MarkupLayerView {
    
    @ViewBuilder
    private func getTextView(_ data: TextMarkupItem, isSelected: Bool = false) -> some View {
        Text(data.text)
            .font(.custom(data.fontName, size: data.fontSize))
            .foregroundStyle(data.color)
            .minimumScaleFactor(.leastNonzeroMagnitude)
            .foregroundColor(.white)
            .frame(width: data.size.width, height: data.size.height)
            .border(.blue, width: isSelected ? 1.2: 0)
            .allowsHitTesting(selection == nil)
            .overlay {
                if isSelected {
                    selectionOverlay
                }
            }
            .rotationEffect(.degrees(data.rotation))
            .position(data.origin)
    }
    
    @ViewBuilder
    private func getDrawingView(_ data: DrawingMarkupItem) -> some View {
        Canvas { ctx, _ in
            for line in data.lines {
                var path = DrawingHelper.createPath(for: line.path)
                path.addLines(line.path)
                ctx.blendMode = line.brush.style == .eraser ? .destinationOut: .color
                ctx.stroke(path, with: .color(line.brush.color), style: StrokeStyle(lineWidth: line.brush.width, lineCap: .round, lineJoin: .round))
            }
        }
    }
    
    @ViewBuilder
    private func getStickerView(_ data: StickerMarkupItem, isSelected: Bool = false) -> some View {
        Image(platformImage: PlatformImage(cgImage: data.previewImage))
            .border(.blue, width: isSelected ? 1.2: 0)
            .allowsHitTesting(selection == nil)
            .overlay {
                if isSelected {
                    selectionOverlay
                }
            }
            .rotationEffect(.degrees(data.rotation))
            .position(data.origin)
    }
}
