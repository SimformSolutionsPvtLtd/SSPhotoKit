//
//  SwiftUIView.swift
//  
//
//  Created by Krunal Patel on 02/01/24.
//

import SwiftUI

struct ScrollableTabBar<T: Hashable & Identifiable, Content: View>: View {
    
    @Binding var selection: T
    var items: [T]
    var onReselect: ((T) -> Void)?
    
    @ViewBuilder var content: (T) -> Content
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 16) {
                    ForEach(items) { item in
                        getTabItemView(for: item)
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
        .frame(height: Sizes.tabBarHeight)
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
        .buttonStyle(.plain)
    }
    
    func onItemReselect(action: @escaping (T) -> Void) -> Self {
        var copy = self
        copy.onReselect = action
        return copy
    }
}
