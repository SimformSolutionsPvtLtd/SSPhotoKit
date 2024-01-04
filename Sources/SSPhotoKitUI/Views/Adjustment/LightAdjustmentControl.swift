//
//  LightAdjustmentControl.swift
//
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct LightAdjustmentControl: View {
    
    @Binding var colorFilter: ColorFilter
    @Binding var hueFilter: HueFilter
    let onEditingChange: (LightAdjustment, Bool) -> Void
    
    var body: some View {
        ScrollView {
            
            VStack {
                ForEach(LightAdjustment.allCases) { adjustment in
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
            SSSlider(value: $colorFilter.brightness.value,
                     in: colorFilter.brightness.range) {
                Text(adjustment.description)
            } trailingLabel: {
                Text("\(colorFilter.brightness.value)")
            } onEditingChanged: { started in
                onEditingChange(.brightness, started)
            }
            
        case .contrast:
            SSSlider(value: $colorFilter.contrast.value,
                     in: colorFilter.contrast.range) {
                Text(adjustment.description)
            } trailingLabel: {
                Text("\(colorFilter.contrast.value)")
            } onEditingChanged: { started in
                onEditingChange(.contrast, started)
            }
            
        case .saturation:
            SSSlider(value: $colorFilter.saturation.value,
                     in: colorFilter.saturation.range) {
                Text(adjustment.description)
            } trailingLabel: {
                Text("\(colorFilter.saturation.value)")
            } onEditingChanged: { started in
                onEditingChange(.saturation, started)
            }
            
        case .hue:
            SSSlider(value: $hueFilter.hue.value,
                     in: hueFilter.hue.range) {
                Text(adjustment.description)
            } trailingLabel: {
                Text("\(hueFilter.hue.value)")
            } onEditingChanged: { started in
                onEditingChange(.hue, started)
            }
        }
    }
}
