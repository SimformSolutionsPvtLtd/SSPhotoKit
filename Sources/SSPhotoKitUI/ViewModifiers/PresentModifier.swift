//
//  PresentEditor.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 16/01/24.
//

import SwiftUI

struct PresentEditor<Label>: ViewModifier where Label: View {
    
    // MARK: - Vars & Lets
    @Binding var isPresented: Bool
    @ViewBuilder var label: () -> Label
    
    // MARK: - Body
    func body(content: Content) -> some View {
        #if os(iOS)
        content.fullScreenCover(isPresented: $isPresented, content: label)
        #elseif os(macOS)
        content.sheet(isPresented: $isPresented, content: label)
        #endif
    }
}

// MARK: - View + Extension
extension View {
    
    func presentEditor<Label>(isPresented: Binding<Bool>, @ViewBuilder label: @escaping () -> Label) -> some View where Label: View {
        modifier(PresentEditor(isPresented: isPresented, label: label))
    }
}
