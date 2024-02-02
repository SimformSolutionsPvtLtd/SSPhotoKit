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
    
    // MARK: - Methods
    func reset() {
        currentLayerIndex = nil
        currentMarkup = .none
        dirtyLayers = layers
    }
    
    func commit() {
        layers = dirtyLayers
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
