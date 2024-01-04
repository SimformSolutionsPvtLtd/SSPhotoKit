//
//  SwiftUIView 2.swift
//
//
//  Created by Krunal Patel on 03/01/24.
//

import SwiftUI
import SSPhotoKitEngine

struct CropMenu: View {
    
    @Binding var isInverted: Bool
    @Binding var currentRatio: CropRatio
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    Button {
                        isInverted = false
                    } label: {
                        Image(.verticalCrop)
                            .resizable()
                            .frame(width: 28, height: 28)
                    }
                    .foregroundStyle(isInverted ? .gray : .white)
                    
                    Button {
                        isInverted = true
                    } label: {
                        Image(.verticalCrop)
                            .resizable()
                            .frame(width: 28, height: 28)
                            .rotationEffect(.degrees(90))
                    }
                    .foregroundStyle(isInverted ? .white : .gray)
                }
                .opacity(currentRatio == .square ? 0 : 1)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(CropRatio.allCases) { ratio in
                            Button {
                                currentRatio = ratio
                            } label: {
                                VStack {
//                                    getShape(for: ratio.ratio, in: CGSize(width: 18, height: 18))
//                                        .stroke(currentRatio == ratio ? .white : .gray, lineWidth: 2)
//                                        .offset(x: 1, y: 1)
//                                        .frame(width: 20, height: 20, alignment: .center)
                                    Text(ratio.ratio.name)
                                        .font(.footnote)
                                }
                            }
                            .foregroundStyle(currentRatio == ratio ? .white : .gray)
                        }
                    }
                    .frame(width: proxy.size.width)
                }
            }
            .padding(.vertical, 8)
        }
        
    }
}

// MARK: - Shapes
extension CropMenu {
    
    private func getShape(for ratio: CropRatio.Ratio, in size: CGSize) -> some Shape {
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
