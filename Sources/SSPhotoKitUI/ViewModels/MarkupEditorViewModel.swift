//
//  MarkupEditorViewModel.swift
//
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI
import SSPhotoKitEngine

class MarkupEditorViewModel : ObservableObject {
    
    // MARK: - Vars & Lets
    @Published var layers: [MarkupLayer] = []
    @Published var currentMarkup: Markup = .none
    @Published var currentLayerIndex: Int?
    @Published var dirtyLayers: [MarkupLayer] = []
    
    var previewFrame: CGRect = .zero
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
        for i in copy.indices {
            
            if case let .drawing = copy[i] {
                copy[i].drawing.updateLines(scale: scale, offset: offset, inverting: inverting)
            }
            
            if inverting {
                copy[i].item.origin *= scale.toCGPoint()
                copy[i].item.origin += offset.toCGPoint()
                copy[i].item.size *= scale
            } else {
                copy[i].item.origin -= offset.toCGPoint()
                copy[i].item.origin /= scale.toCGPoint()
                copy[i].item.size /= scale
            }
        }
        return copy
    }
    
    
    
    func createCommand<Content>(@ViewBuilder renderer: @escaping ([MarkupLayer]) -> Content) -> some EditingCommand where Content : View {
        
        MarkupEditingCommand(layers: layers, renderer: renderer)
    }
}

// MARK: - Enums
extension MarkupEditorViewModel {
    
    enum ArrangeAction {
        case moveUp, moveDown
    }
}
