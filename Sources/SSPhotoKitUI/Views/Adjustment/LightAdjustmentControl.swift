//
//  LightAdjustmentControl.swift
//
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct LightAdjustmentControl: View {
    
    @Environment(\.adjustmentConfiguration) private var config: AdjustmentConfiguration
    @Binding var colorFilter: ColorFilter
    @Binding var hueFilter: HueFilter
    let onEditingChange: (LightAdjustment, Bool) -> Void
    
    var body: some View {
        ScrollView {
            
            VStack {
                ForEach(LightAdjustment.getAllowedLightAdjustments(with: config.allowedAdjustments)) { adjustment in
                    getSlider(for: adjustment)
                }
            }            
        }
    }
}

// MARK: - Views
extension LightAdjustmentControl {
    
    @ViewBuilder
    private func getSlider(for adjustment: LightAdjustment) -> some View {
        switch adjustment {
            
        case .brightness:
            SSSlider(value: $colorFilter.brightness,
                     in: colorFilter.$brightness) {
                Text(adjustment.description)
            } trailingLabel: {
                Text("\(colorFilter.brightness)")
            } onEditingChanged: { started in
                onEditingChange(.brightness, started)
            }
            
        case .contrast:
            SSSlider(value: $colorFilter.contrast,
                     in: colorFilter.$contrast) {
                Text(adjustment.description)
            } trailingLabel: {
                Text("\(colorFilter.contrast)")
            } onEditingChanged: { started in
                onEditingChange(.contrast, started)
            }
            
        case .saturation:
            SSSlider(value: $colorFilter.saturation,
                     in: colorFilter.$saturation) {
                Text(adjustment.description)
            } trailingLabel: {
                Text("\(colorFilter.saturation)")
            } onEditingChanged: { started in
                onEditingChange(.saturation, started)
            }
            
        case .hue:
            SSSlider(value: $hueFilter.hue,
                     in: hueFilter.$hue) {
                Text(adjustment.description)
            } trailingLabel: {
                Text("\(hueFilter.hue)")
            } onEditingChanged: { started in
                onEditingChange(.hue, started)
            }
        }
    }
}
