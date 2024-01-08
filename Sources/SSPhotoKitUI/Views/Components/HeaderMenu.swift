//
//  SwiftUIView.swift
//  
//
//  Created by Krunal Patel on 03/01/24.
//

import SwiftUI

struct HeaderMenu: View {
    
    var disableOptions: DisableOptions = []
    let menuAction: (MenuAction) -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            Button {
                menuAction(.undo)
            } label: {
                Text("Undo")
            }
            .disabled(disableOptions.contains(.undo))
            
            Spacer()
            
            Button {
                menuAction(.redo)
            } label: {
                Text("Redo")
            }
            .disabled(disableOptions.contains(.redo))
            
            Spacer()
            
            Button {
                menuAction(.discard)
            } label: {
                Image(systemName: "xmark")
            }
            .disabled(disableOptions.contains(.discard))

            Spacer()
            
            Button {
                menuAction(.save)
            } label: {
                Image(systemName: "checkmark")
            }
            .disabled(disableOptions.contains(.save))

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

// MARK: - Header Menu Options
extension HeaderMenu {
    
    struct DisableOptions : OptionSet {
        
        let rawValue: UInt
        
        static let undo = DisableOptions(rawValue: 1 << 0)
        static let redo = DisableOptions(rawValue: 1 << 1)
        static let save = DisableOptions(rawValue: 1 << 2)
        static let discard = DisableOptions(rawValue: 1 << 3)
    }
}
