//
//  ScrollableTabBar.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 02/01/24.
//

import SwiftUI

struct ScrollableTabBar<T: Hashable & Identifiable, Content: View>: View {
    
    // MARK: - Vars & Lets
    @Binding var selection: T
    var items: [T]
    var onReselect: ((T) -> Void)?
    
    @ViewBuilder var content: (T) -> Content
    
    // MARK: - Body
    var body: some View {
        
        ViewThatFits(in: .horizontal) {
            
            tabItems
            
            ScrollView(.horizontal, showsIndicators: false) {
                tabItems
            }
        }
    }
}

// MARK: - Views
extension ScrollableTabBar {
    
    @ViewBuilder
    private var tabItems: some View {
        HStack(alignment: .center, spacing: 16) {
            ForEach(items) { item in
                getTabItemView(for: item)
            }
        }
    }
    
    @ViewBuilder
    private func getTabItemView(for item: T) -> some View {
        Button {
            if selection == item {
                onReselect?(item)
            } else {
                selection = item
            }
        } label: {
            content(item)
        }
        .buttonStyle(.primary)
    }
}

// MARK: - Methods
extension ScrollableTabBar {
    
    func onItemReselect(action: @escaping (T) -> Void) -> Self {
        var copy = self
        copy.onReselect = action
        return copy
    }
}
