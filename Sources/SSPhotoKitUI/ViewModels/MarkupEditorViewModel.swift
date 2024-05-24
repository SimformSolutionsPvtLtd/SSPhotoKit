//
//  MarkupEditorViewModel.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

class MarkupEditorViewModel: ObservableObject {
    
    // MARK: - Vars & Lets
    @Published var layers: [MarkupLayer] = []
    @Published var currentMarkup: Markup = .none
    @Published var currentLayerIndex: Int?
    @Published var dirtyLayers: [MarkupLayer] = []
    
    var containerSize: CGSize = .zero
    var scale: CGSize = .one
    var offset: CGSize = .zero
    
    var canEditCurrentLayer: Bool {
        dirtyLayers.count > currentLayerIndex ?? 0
    }
    
    // MARK: - Methods
    func setupEditingLayers() {
        dirtyLayers = scaling(layers: layers, with: scale, offset: offset, inverting: true)
    }
    
    func reset() {
        currentLayerIndex = nil
        currentMarkup = .none
        dirtyLayers.removeAll()
    }
    
    func commit() {
        layers = scaling(layers: dirtyLayers, with: scale, offset: offset)
    }
    
    func canArrange(_ action: ArrangeAction) -> Bool {
        guard let currentLayerIndex else { return false }
        
        return switch action {
        case .moveUp:
            currentLayerIndex < dirtyLayers.count - 1
        case .moveDown:
            currentLayerIndex > 0
        }
    }
    
    func arrange(_ action: ArrangeAction) {
        guard let index = currentLayerIndex, canArrange(action) else { return }
        
        switch action {
        case .moveUp:
            dirtyLayers.swapAt(index, index + 1)
            currentLayerIndex = index + 1
        case .moveDown:
            dirtyLayers.swapAt(index, index - 1)
            currentLayerIndex = index - 1
        }
    }
    
    func scaling(layers: [MarkupLayer], with scale: CGSize, offset: CGSize, inverting: Bool = false) -> [MarkupLayer] {
        var copy = layers
        for index in copy.indices {
            let center = containerSize / CGSize(width: 2, height: 2)
            let scaledOffset = offset * scale
            if case .drawing = copy[index] {
                copy[index].drawing.update(scale: scale, offset: scaledOffset, center: center, inverting: inverting)
            }
            
            let origin = copy[index].item.origin.toCGSize()
            if inverting {
                let newOffset = ((origin - center) * scale) + center + scaledOffset
                copy[index].item.origin = newOffset.toCGPoint()
                copy[index].item.size *= scale
            } else {
                let newOffset = ((origin - center - scaledOffset) / scale) + center
                copy[index].item.origin = newOffset.toCGPoint()
                copy[index].item.size /= scale
            }
        }
        return copy
    }
    
    func createCommand<Content>(@ViewBuilder renderer: @escaping ([MarkupLayer]) -> Content) -> some EditingCommand where Content: View {
        MarkupEditingCommand(layers: layers, renderer: renderer)
    }
}

// MARK: - Enums
extension MarkupEditorViewModel {
    
    enum ArrangeAction {
        case moveUp, moveDown
    }
}
