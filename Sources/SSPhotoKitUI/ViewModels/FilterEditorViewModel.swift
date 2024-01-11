//
//  FilterEditorViewModel.swift
//  SSPhotoKitUI
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
    
    @Published var currentCategory: String = ""
    @Published var currentImage: CIImage!
    @Published var previews: [String: [FilterOperation]] = [:]
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
    func createPreviews(with filters: GroupedFilters) {
        filters.forEach { category, filters in
            previews[category] = filters.map { filter in
                FilterOperation(filter: filter, name: filter.name)
            }
        }
    }
    
    func loadPreview(with filters: GroupedFilters) async {
        createPreviews(with: filters)
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
    
    // MARK: - Initializer
    init(image: CIImage) {
        self.originalImage = image
        self.currentImage = image
        self.thumbnailImage = image.resizing(CGSize(width: 80, height: 80))
        self.currentFilter = original
    }
}
