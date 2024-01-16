//
//  FilterEditor.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

struct FilterEditor: View {
    
    // MARK: - Vars & Lets
    @Environment(\.filterConfiguration) private var config: FilterConfiguration
    @EnvironmentObject var model: EditorViewModel
    @EnvironmentObject var engine: SSPhotoKitEngine
    @StateObject var filterViewModel: FilterEditorViewModel
    @State var task: Task<(), Never>?
    
    private var imageSize: CGSize {
        filterViewModel.currentImage.extent.size
    }
    
    // MARK: - Body
    var body: some View {
        
        ZStack {
            ImagePreview(imageSource: .coreImage($filterViewModel.currentImage), gesturesEnabled: false)
        }
        .overlay(alignment: .bottom) {
            footerView
        }
        .task {
            await filterViewModel.loadPreview(with: config.filterGroups)
            if let category = config.filterGroups.first?.key {
                filterViewModel.currentCategory = category
            }
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
    private var footerView: some View {
        VStack {
            intensityController
            
            categories
            
            filtersPreview
            
            Divider()
                .frame(height: 20)
            
            FooterMenu(filterViewModel.currentCategory) {
                Task {
                    await engine.apply(filterViewModel.createCommand())
                    model.resetEditor()
                }
            } onDiscard: {
                model.resetEditor()
            }
        }
        .background()
    }
    
    @ViewBuilder
    private var intensityController: some View {
        SSSlider(value: $filterViewModel.currentFilter.filter.intensity)
            .opacity(filterViewModel.currentFilter == filterViewModel.original ? 0: 1)
    }
    
    @ViewBuilder
    private var categories: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(config.filterGroups.keys.sorted(by: >), id: \.self) { category in
                    Button {
                        filterViewModel.currentCategory = category
                    } label: {
                        Text(category)
                            .font(.subheadline)
                    }
                    .buttonStyle(.primary)
                    .foregroundStyle(filterViewModel.currentCategory == category ? .white: .gray)
                }
            }
        }
    }
    
    @ViewBuilder
    private var filtersPreview: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                FilterThumbnailPreview(filter: filterViewModel.original, selection: $filterViewModel.currentFilter)
                
                ForEach(filterViewModel.previews[filterViewModel.currentCategory] ?? []) { filter in
                    FilterThumbnailPreview(filter: filter, selection: $filterViewModel.currentFilter)
                }
            }
            .frame(height: 100)
        }
    }
}
