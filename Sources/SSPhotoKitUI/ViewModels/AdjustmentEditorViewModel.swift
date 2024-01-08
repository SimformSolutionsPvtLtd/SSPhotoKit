//
//  File.swift
//
//
//  Created by Krunal Patel on 03/01/24.
//

import SwiftUI
import SSPhotoKitEngine
import Combine

@MainActor
class AdjustmentEditorViewModel : ObservableObject {
    
    // MARK: - Vars & Lets
    let originalImage: CIImage
    @Published var currentImage: CIImage
    @Published var tempImage: CIImage
    @Published var isUpdating: Bool = false
    
    @Published var currentAdjustment: Adjustment = .none
    
    // MARK: - Light Adjustment
    @Published var colorFilter = ColorFilter()
    @Published var hueFilter = HueFilter()
    
    // MARK: - Blur Adjustment
    @Published var blurFilter = GaussianBlurFilter()
    
    var allFilters: [any Filter] { [colorFilter, hueFilter, blurFilter] }
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Methods
    private func observeAdjustment() {
        _currentAdjustment.projectedValue
            .sink { adjustment in
                Task { [weak self]  in
                    guard let self else { return }
                    
                    Task {
                        currentImage = await allFilters.apply(to: originalImage)
                    }
                    
                    isUpdating = true
                    switch adjustment {
                    case .light:
                        tempImage = await allFilters
                            .filterNot(ofType: ColorFilter.self)
                            .filterNot(ofType: HueFilter.self)
                            .apply(to: originalImage)
                    case .color:
                        break
                    case .blur:
                        tempImage = await allFilters
                            .filterNot(ofType: GaussianBlurFilter.self)
                            .apply(to: originalImage)
                    case .none:
                        break
                    }
                    isUpdating = false
                }
            }
            .store(in: &cancellables)
    }
    
    func updateImage<T>(exclude type: T.Type) async {
        tempImage = await allFilters
            .filterNot(ofType: type)
            .apply(to: originalImage)
    }
    
    func createCommand() -> some EditingCommand {
        MultiEditingCommand(colorFilter, hueFilter, blurFilter)
    }
    
    // MARK: - Initializer
    init(image: CIImage) {
        originalImage = image
        currentImage = image
        tempImage = image
        
        observeAdjustment()
    }
}
