//
//  AdjustmentEditor.swift
//
//
//  Created by Krunal Patel on 03/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

struct AdjustmentEditor: View {
    
    // MARK: - Vars & Lets
    @Environment(\.adjustmentConfiguration) private var config: AdjustmentConfiguration
    @EnvironmentObject var model: EditorViewModel
    @EnvironmentObject var engine: SSPhotoKitEngine
    @StateObject var adjustmentViewModel: AdjustmentEditorViewModel
    
    private var imageSize: CGSize {
        engine.previewImage.extent.size
    }
    
    // MARK: - Body
    var body: some View {
        
        ZStack {
            ImagePreview(imageSource: .coreImage($adjustmentViewModel.currentImage))
                .onTapGesture {
                    adjustmentViewModel.currentAdjustment = .none
                }
        }
        .overlay(alignment: .bottom) {
            footerView
        }
    }
    
    // MARK: - Initializer
    init(image: CIImage) {
        _adjustmentViewModel = StateObject(wrappedValue: AdjustmentEditorViewModel(image: image))
    }
}

// MARK: - Views
extension AdjustmentEditor {
    
    @ViewBuilder
    private var footerView: some View {
        VStack {
            adjustmentControls
                .padding(.horizontal, 12)
                .padding(.top, 8)
            
            adjustmentMenu
            
            FooterMenu(adjustmentViewModel.currentAdjustment.description) {
                Task {
                    await engine.apply(adjustmentViewModel.createCommand())
                    model.resetEditor()
                }
            } onDiscard: {
                model.resetEditor()
            }
        }
        .background(.black.opacity(0.5))
    }
    
    @ViewBuilder
    private var adjustmentControls: some View {
        switch adjustmentViewModel.currentAdjustment {
        case .light:
            LightAdjustmentControl(
                colorFilter: $adjustmentViewModel.colorFilter,
                hueFilter: $adjustmentViewModel.hueFilter,
                onEditingChange: handleLightAdjustmentChange
            )
            .frame(maxHeight: 130)
            .onChange(of: adjustmentViewModel.colorFilter) { _ in
                guard !adjustmentViewModel.isUpdating else { return }
                adjustmentViewModel.currentImage = adjustmentViewModel.colorFilter.apply(to: adjustmentViewModel.tempImage)
            }
            .onChange(of: adjustmentViewModel.hueFilter) { _ in
                guard !adjustmentViewModel.isUpdating else { return }
                adjustmentViewModel.currentImage = adjustmentViewModel.hueFilter.apply(to: adjustmentViewModel.tempImage)
            }
        case .blur:
            BlurAdjustmentControl(blur: $adjustmentViewModel.blurFilter) {
                adjustmentViewModel.currentImage = adjustmentViewModel.blurFilter.apply(to: adjustmentViewModel.tempImage)
            }
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var adjustmentMenu: some View {
        ScrollableTabBar(selection: $adjustmentViewModel.currentAdjustment,
                         items: Adjustment.getAllowedAdjustments(with: config.allowedAdjustments)) { item in
            VStack(spacing: 6) {
                Image(systemName: item.icon)
                    .font(.system(size: 26, design: .rounded))
                    .foregroundStyle(.white.opacity(adjustmentViewModel.currentAdjustment == item ? 1: 0.6))
                
                Circle()
                    .fill(.white)
                    .frame(height: adjustmentViewModel.currentAdjustment == item ? 6: 0)
            }
        }
        .onItemReselect { _ in
            adjustmentViewModel.currentAdjustment = .none
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
    }
}

// MARK: - Methods
extension AdjustmentEditor {
    
    private func handleLightAdjustmentChange(adjustment: LightAdjustment, started: Bool) {
        guard started else { return }
        adjustmentViewModel.isUpdating = true
        Task {
            switch adjustment {
            case .brightness, .contrast, .saturation:
                await adjustmentViewModel.updateImage(exclude: ColorFilter.self)
            case .hue:
                await adjustmentViewModel.updateImage(exclude: HueFilter.self)
            }
            adjustmentViewModel.isUpdating = false
        }
    }
}
