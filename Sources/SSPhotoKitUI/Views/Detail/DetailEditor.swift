//
//  DetailEditor.swift
//
//
//  Created by Krunal Patel on 08/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct DetailEditor: View {
    
    // MARK: - Vars & Lets
    @EnvironmentObject var model: EditorViewModel
    @EnvironmentObject var engine: SSPhotoKitEngine
    @StateObject var detailViewModel: DetailEditorViewModel
    
    private var imageSize: CGSize {
        engine.previewImage.extent.size
    }
    
    // MARK: - Body
    var body: some View {
        
        ZStack {
            ImagePreview(imageSource: .coreImage($detailViewModel.currentImage), gesturesEnabled: false)
        }
        .overlay(alignment: .bottom) {
            footerView
        }
    }
    
    // MARK: - Initializer
    init(image: CIImage) {
        _detailViewModel = StateObject(wrappedValue: DetailEditorViewModel(image: image))
    }
}

// MARK: - Views
extension DetailEditor {
    
    @ViewBuilder
    private var footerView: some View {
        VStack {
            detailMenu
            
            detailControls
                .frame(height: 130)
            
            Divider()
                .frame(height: 20)
            
            FooterMenu(detailViewModel.currentDetail.description) {
                Task {
                    await engine.apply(detailViewModel.createCommand())
                    model.resetEditor()
                }
            } onDiscard: {
                model.resetEditor()
            }
        }
        .background()
    }
    
    @ViewBuilder
    private var detailControls: some View {
        switch detailViewModel.currentDetail {
        case .sharpen:
            SharpenDetailControl(sharpen: $detailViewModel.sharpenFilter) {
                detailViewModel.currentImage = detailViewModel.sharpenFilter.apply(to: detailViewModel.tempImage)
            }
        case .noise:
            NoiseDetailControl(noise: $detailViewModel.noiseFilter) {
                detailViewModel.currentImage = detailViewModel.noiseFilter.apply(to: detailViewModel.tempImage)
            }
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var detailMenu: some View {
        ScrollableTabBar(selection: $detailViewModel.currentDetail, items: Detail.allCases) { detail in
            Text(detail.description)
                .font(.system(size: 16, design: .rounded))
                .foregroundStyle(.white.opacity(detailViewModel.currentDetail == detail ? 1 : 0.6))
        }
    }
}
