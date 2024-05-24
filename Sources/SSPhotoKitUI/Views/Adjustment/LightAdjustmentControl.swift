//
//  LightAdjustmentControl.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

struct LightAdjustmentControl: View {
    
    // MARK: - Vars & Lets
    @Environment(\.adjustmentConfiguration) private var config: AdjustmentConfiguration
    @Binding var colorFilter: ColorFilter
    @Binding var hueFilter: HueFilter
    let onEditingChange: (LightAdjustment, Bool) -> Void
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                    .frame(height: 12)
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
                Text("\(colorFilter.brightness.roundedString(to: 2))")
            } onEditingChanged: { started in
                onEditingChange(.brightness, started)
            }
            
        case .contrast:
            SSSlider(value: $colorFilter.contrast,
                     in: colorFilter.$contrast) {
                Text(adjustment.description)
            } trailingLabel: {
                Text("\(colorFilter.contrast.roundedString(to: 2))")
            } onEditingChanged: { started in
                onEditingChange(.contrast, started)
            }
            
        case .saturation:
            SSSlider(value: $colorFilter.saturation,
                     in: colorFilter.$saturation) {
                Text(adjustment.description)
            } trailingLabel: {
                Text("\(colorFilter.saturation.roundedString(to: 2))")
            } onEditingChanged: { started in
                onEditingChange(.saturation, started)
            }
            
        case .hue:
            SSSlider(value: $hueFilter.hue,
                     in: hueFilter.$hue) {
                Text(adjustment.description)
            } trailingLabel: {
                Text("\(hueFilter.hue.roundedString(to: 2))")
            } onEditingChanged: { started in
                onEditingChange(.hue, started)
            }
        }
    }
}
