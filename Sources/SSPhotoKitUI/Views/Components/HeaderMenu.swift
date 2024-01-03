//
//  SwiftUIView.swift
//  
//
//  Created by Krunal Patel on 03/01/24.
//

import SwiftUI

struct HeaderMenu: View {
    
    let menuAction: (MenuAction) -> Void
    var isEnabled: (MenuAction) -> Bool = { _ in true }
    
    var body: some View {
        HStack {
            Spacer()
            
            Button {
                menuAction(.undo)
            } label: {
                Text("Undo")
            }
            .disabled(!isEnabled(.undo))
            
            Spacer()
            
            Button {
                menuAction(.redo)
            } label: {
                Text("Redo")
            }
            .disabled(!isEnabled(.redo))
            
            Spacer()
            
            Button {
                menuAction(.discard)
            } label: {
                Image(systemName: "xmark")
            }
            .disabled(!isEnabled(.discard))

            Spacer()
            
            Button {
                menuAction(.save)
            } label: {
                Image(systemName: "checkmark")
            }
            .disabled(!isEnabled(.save))

            Spacer()
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
    }
}

// MARK: - Header Menu Action
enum MenuAction {
    case undo, redo, save, discard
}
