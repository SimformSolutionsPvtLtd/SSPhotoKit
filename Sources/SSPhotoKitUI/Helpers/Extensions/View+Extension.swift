//
//  View+Extension.swift
//  SSPhotoKitUI
//
//  Created by Krunal Patel on 02/01/24.
//

import SwiftUI
import SSPhotoKitEngine

// MARK: - Configurations
extension View {
    
    // MARK: - Editor Configuration
    public func editorConfig(allowedEditors: EditorConfiguration.AllowedEditorOptions = .all) -> some View {
        environment(\.editorConfiguration, .init(allowedEditors: allowedEditors))
    }
    
    // MARK: - Crop Configuration
    public func cropConfig(ratios: [AspectRatio],
                           options: CropConfiguration.RatioOptions = .all,
                           labelType: CropConfiguration.LabelType = .text) -> some View {
        environment(\.cropConfiguration, .init(customRatios: ratios, ratioOptions: options, labelType: labelType))
    }
    
    // MARK: - Adjustment Configuration
    public func adjustmentConfig(allowedAdjustments: AdjustmentConfiguration.AllowedAdjustmentOptions = .all) -> some View {
        environment(\.adjustmentConfiguration, .init(allowedAdjustments: allowedAdjustments))
    }
    
    // MARK: - Markup Configuration
    public func filterConfig(filterGroups: GroupedFilters = [:],
                             filterOptions: FilterConfiguration.FilterOptions = .all) -> some View {
        environment(\.filterConfiguration, .init(customFilterGroups: filterGroups, filterOptions: filterOptions))
    }
    
    // MARK: - Markup Configuration
    public func markupConfig(stickers: [PlatformImage] = [],
                             stickerOptions: MarkupConfiguration.StickerOptions = .gallery,
                             allowedMarkups: MarkupConfiguration.AllowedMarkupOptions = .all) -> some View {
        environment(\.markupConfiguration, .init(customStickers: stickers, stickerOptions: stickerOptions, allowedMarkups: allowedMarkups))
    }
}


// MARK: - Bounds
extension View {
    
    var bounds: CGRect {
        #if os(iOS)
        return UIScreen.main.bounds
        #else
        return NSScreen.main!.frame
        #endif
    }
}

// MARK: - Conditional Modifier
extension View {
    
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
