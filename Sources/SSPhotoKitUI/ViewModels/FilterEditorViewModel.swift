//
//  FilterEditorViewModel.swift
//
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI
import SSPhotoKitEngine

@MainActor
class FilterEditorViewModel : ObservableObject {
    
    // MARK: - Vars & Lets
    let originalImage: CIImage
    let thumbnailImage: CIImage
    
    @Published var currentCategory: FilterCategory = .creativeArtistic
    @Published var currentImage: CIImage!
    @Published var previews: [FilterCategory: [FilterOperation]] = [:]
    @Published var currentFilter: FilterOperation
    var original: FilterOperation = .original
    
    private lazy var ciContext: CIContext = {
        if let device = MTLCreateSystemDefaultDevice() {
            return CIContext(mtlDevice: device)
        } else {
            print("Can't create Metal device, switching to default context.")
            return CIContext()
        }
    }()
    
    // MARK: - Methods
    func createPreviews() {
        
        FilterCategory.allCases.forEach { category in
            let filters = category.filters.map { filter in
                FilterOperation(filter: filter, name: filter.name)
            }
            previews[category] = filters
        }
    }
    
    func loadPreview() async {
        await original.previewImage = createPreview(for: .original)
        currentFilter = original
        
        for category in previews.keys {
            let filters = previews[category]!
            for i in filters.indices {
                previews[category]![i].previewImage = await createPreview(for: filters[i].filter)
            }
        }
    }
    
    func createCommand() -> some EditingCommand {
        currentFilter.filter.asAny()
    }
    
    private func createPreview<F: Filter>(for filter: F) async -> CGImage {
        let image = await filter.apply(to: thumbnailImage)
        return ciContext.createCGImage(image, from: image.extent)!
    }
    
    private func createPreview(for filter: any Filter) async -> CGImage {
        let image = await filter.apply(to: thumbnailImage)
        return ciContext.createCGImage(image, from: image.extent)!
    }
    
    
    // MARK: - Initializer
    init(image: CIImage) {
        self.originalImage = image
        self.thumbnailImage = image.resizing(CGSize(width: 80, height: 80))
        self.currentImage = thumbnailImage
        self.currentFilter = original
        createPreviews()
    }
}
