//
//  DetailEditorViewModel.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 08/01/24.
//

import SwiftUI
import Combine
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

@MainActor
class DetailEditorViewModel: ObservableObject {
    
    // MARK: - Vars & Lets
    let originalImage: CIImage
    @Published var currentImage: CIImage
    var tempImage: CIImage
    
    @Published var currentDetail: Detail = .sharpen
    
    // MARK: - Sharpen
    @Published var sharpenFilter = SharpenFilter()
    
    // MARK: - Noise
    @Published var noiseFilter = NoiseFilter()
    
    private var allFilters: [any Filter] { [sharpenFilter, noiseFilter] }
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Methods
    func createCommand() -> some EditingCommand {
        MultiEditingCommand(sharpenFilter, noiseFilter)
    }
    
    private func observeDetail() {
        _currentDetail.projectedValue
            .sink { detail in
                Task { [weak self] in
                    guard let self else { return }
                    
                    Task { [weak self] in
                        guard let self else { return }
                        currentImage = await allFilters.apply(to: originalImage)
                    }
                    
                    switch detail {
                    case .sharpen:
                        tempImage = await allFilters
                            .filterNot(ofType: SharpenFilter.self)
                            .apply(to: originalImage)
                    case .noise:
                        tempImage = await allFilters
                            .filterNot(ofType: NoiseFilter.self)
                            .apply(to: originalImage)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Initializer
    init(image: CIImage) {
        originalImage = image
        currentImage = image
        tempImage = image
        
        observeDetail()
    }
}
