//
//  FilterThumbnailPreview.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

struct FilterThumbnailPreview: View {
    
    // MARK: - Vars & Lets
    let filter: FilterOperation
    @Binding var selection: FilterOperation
    
    private var isSelected: Bool {
        filter.id == selection.id
    }
    
    // MARK: - Body
    var body: some View {
        Button {
            selection = filter
        } label: {
            if let previewImage = filter.previewImage {
                Image(platformImage: PlatformImage(cgImage: previewImage))
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
            }
        }
        .frame(width: 80, height: 80)
        .overlay(alignment: .bottom) {
            Text(filter.name)
                .lineLimit(1)
                .font(.caption)
                .padding(2)
                .frame(maxWidth: .infinity)
                .background(.black.opacity(0.8))
        }
        .overlay {
            Color.black.opacity(isSelected ? 0.4: 0)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 4)
                .inset(by: 1)
                .stroke(.white, lineWidth: isSelected ? 1: 0)
        }
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
