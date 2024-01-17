//
//  CropMenu.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 03/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

struct CropMenu: View {
    
    // MARK: - Vars & Lets
    @Environment(\.cropConfiguration) private var config: CropConfiguration
    let cropRatios: [AspectRatio]
    @Binding var isInverted: Bool
    @Binding var currentRatio: AspectRatio
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 20) {
                Button {
                    isInverted = false
                } label: {
                    Image("vertical_crop", bundle: .module)
                        .resizable()
                        .frame(width: 28, height: 28)
                }
                .foregroundStyle(isInverted ? .gray: .white)
                
                Button {
                    isInverted = true
                } label: {
                    Image("vertical_crop", bundle: .module)
                        .resizable()
                        .frame(width: 28, height: 28)
                        .rotationEffect(.degrees(90))
                }
                .foregroundStyle(isInverted ? .white: .gray)
            }
            .buttonStyle(.primary)
            .opacity(currentRatio.value == 1 ? 0: 1)
            
            ViewThatFits {
                    cropRatioViews
                
                ScrollView(.horizontal, showsIndicators: false) {
                    cropRatioViews
                }
            }
        }
    }
}

// MARK: - Views
extension CropMenu {
    
    @ViewBuilder
    private var cropRatioViews: some View {
        HStack(spacing: 12) {
            ForEach(cropRatios) { ratio in
                Button {
                    currentRatio = ratio
                } label: {
                    VStack(spacing: 0) {
                        if config.labelType != .text {
                            getShape(for: ratio, in: CGSize(width: 18, height: 18))
                                .stroke(currentRatio == ratio ? .white: .gray, lineWidth: 2)
                                .offset(x: 1, y: 1)
                                .frame(width: 20, height: 20, alignment: .center)
                        }
                        
                        if config.labelType != .icon {
                            Text(ratio.name)
                                .font(.footnote)
                        }
                    }
                }
                .foregroundStyle(currentRatio == ratio ? .white: .gray)
            }
        }
    }
}

// MARK: - Shapes
extension CropMenu {
    
    private func getShape(for ratio: AspectRatio, in size: CGSize) -> some Shape {
        let minSize = min(size.width, size.height)
        
        var width = size.width
        var height = size.height
        if ratio.height > ratio.width {
            width = minSize * (CGFloat(ratio.width) / CGFloat(ratio.height))
        } else {
            height = minSize * (CGFloat(ratio.height) / CGFloat(ratio.width))
        }
        
        return Rectangle()
            .size(width: width, height: height)
            .offset(x: (size.width - width) / 2, y: (size.height - height) / 2)
    }
}
