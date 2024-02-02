//
//  AdjustmentEditor.swift
//
//
//  Created by Krunal Patel on 03/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct AdjustmentEditor: View {
    
    @EnvironmentObject var model: SSPKViewModel
    @StateObject var adjustmentViewModel: AdjustmentEditorViewModel
    
    private var imageSize: CGSize {
        model.engine.previewImage.extent.size
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            
            MetalView(image: $adjustmentViewModel.currentImage)
                .frame(width: imageSize.width, height: imageSize.height)
            
            Spacer()
            
            adjustmentControls
                .frame(height: 130)
            
            adjustmentMenu
            
            Divider()
                .frame(height: 20)
            
            FooterMenu("Adjustments") {
                Task {
                    await model.engine.apply(adjustmentViewModel.createCommand())
                    model.resetEditor()
                }
            } onDiscard: {
                model.resetEditor()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Initializer
    init(image: CIImage) {
        _adjustmentViewModel = StateObject(wrappedValue: AdjustmentEditorViewModel(image: image))
    }
}

// MARK: - Views
extension AdjustmentEditor {
    
    @ViewBuilder
    private var adjustmentControls: some View {
        switch adjustmentViewModel.currentAdjustment {
        case .light:
            LightAdjustmentControl(
                colorFilter: $adjustmentViewModel.colorFilter,
                hueFilter: $adjustmentViewModel.hueFilter,
                onEditingChange: handleLightAdjustmentChange
            )
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
        ScrollableTabBar(selection: $adjustmentViewModel.currentAdjustment, items: Adjustment.allCases.filter { $0 != .none}) { item in
            VStack(spacing: 6) {
                Image(systemName: item.icon)
                    .font(.system(size: 26, design: .rounded))
                    .foregroundStyle(.white.opacity(adjustmentViewModel.currentAdjustment == item ? 1 : 0.6))
                
                Circle()
                    .fill(.white)
                    .frame(height: adjustmentViewModel.currentAdjustment == item ? 6 : 0)
            }
        }
        .onItemReselect { _ in
            adjustmentViewModel.currentAdjustment = .none
        }
        .padding(.horizontal, 16)
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
