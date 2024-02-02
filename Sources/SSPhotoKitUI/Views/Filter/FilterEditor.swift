//
//  FilterEditor.swift
//
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct FilterEditor: View {
    
    @EnvironmentObject var model: SSPKViewModel
    @StateObject var filterViewModel: FilterEditorViewModel
    @State var task: Task<(), Never>?
    
    private var imageSize: CGSize {
        filterViewModel.currentImage.extent.size
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            
            MetalView(image: $filterViewModel.currentImage)
                .frame(width: imageSize.width, height: imageSize.height)
            
            Spacer()
            
            intensityController
            
            categories
            
            filtersPreview
            
            Divider()
                .frame(height: 20)
            
            FooterMenu(filterViewModel.currentCategory.rawValue) {
                Task {
                    await model.engine.apply(filterViewModel.createCommand())
                    model.resetEditor()
                }
            } onDiscard: {
                model.resetEditor()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            await filterViewModel.loadPreview()
        }
        .onReceive(filterViewModel.$currentFilter) { _ in
            task?.cancel()
            task = Task {
                filterViewModel.currentImage = await filterViewModel.currentFilter.filter.apply(to: filterViewModel.originalImage)
            }
            
        }
        .onChange(of: filterViewModel.currentFilter.filter.intensity) { _ in
            task?.cancel()
            task = Task {
                filterViewModel.currentImage = await filterViewModel.currentFilter.filter.apply(to: filterViewModel.originalImage)
            }
        }
    }
    
    // MARK: - Initializer
    init(image: CIImage) {
        self._filterViewModel = StateObject(wrappedValue: FilterEditorViewModel(image: image))
    }
}

// MARK: - Views
extension FilterEditor {
    
    @ViewBuilder
    private var intensityController: some View {
        SSSlider(value: $filterViewModel.currentFilter.filter.intensity)
            .opacity(filterViewModel.currentFilter == filterViewModel.original ? 0 : 1)
    }
    
    @ViewBuilder
    private var categories: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(FilterCategory.allCases) { category in
                    Button {
                        filterViewModel.currentCategory = category
                    } label: {
                        Text(category.rawValue)
                            .font(.subheadline)
                    }
                    .foregroundStyle(filterViewModel.currentCategory == category ? .white : .gray)

                }
            }
        }
    }
    
    @ViewBuilder
    private var filtersPreview: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12)  {
                FilterThumbnailPreview(filter: filterViewModel.original, selection: $filterViewModel.currentFilter)
                
                ForEach(filterViewModel.previews[filterViewModel.currentCategory] ?? []) { filter in
                    FilterThumbnailPreview(filter: filter, selection: $filterViewModel.currentFilter)
                }
            }
            .frame(height: 100)
        }
    }
}

