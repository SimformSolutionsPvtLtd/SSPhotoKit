//
//  PrimaryButtonStyle.swift
//  SSPhotoKitUI
//
//  Created by Krunal Patel on 11/01/24.
//

import SwiftUI

public struct PrimaryButtonStyle : ButtonStyle {
    
    @Environment(\.isEnabled) var isEnabled: Bool
    
    public func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .padding(6)
            .contentShape(.rect)
            .opacity(configuration.isPressed ? 0.6 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .opacity(isEnabled ? 1 : 0.6)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    
    public static var primary: PrimaryButtonStyle { .init() }
}
