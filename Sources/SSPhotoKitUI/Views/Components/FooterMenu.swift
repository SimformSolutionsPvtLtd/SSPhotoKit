//
//  FooterMenu.swift
//
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI

struct FooterMenu: View {
    
    let title: String
    let disable: DisableOption
    let onSave: () -> Void
    let onDiscard: () -> Void
    
    var body: some View {
        
        HStack {
            Button {
                onDiscard()
            } label: {
                Image(systemName: "xmark")
            }
            .foregroundStyle(disable.contains(.discard) ? .gray : .white)
            .disabled(disable.contains(.discard))
            
            Spacer()
            
            Text(title)
            
            Spacer()
            
            
            Button {
                onSave()
            } label: {
                Image(systemName: "checkmark")
            }
            .foregroundStyle(disable.contains(.save) ? .gray : .white)
            .disabled(disable.contains(.save))
            
        }
        .font(.system(.headline, weight: .medium))
        .padding(.horizontal, 24)
    }
    
    init(_ title: String, disable: DisableOption = [], onSave: @escaping () -> Void, onDiscard: @escaping () -> Void) {
        self.title = title
        self.disable = disable
        self.onSave = onSave
        self.onDiscard = onDiscard
    }
}

// MARK: - Options
extension FooterMenu {
    
    struct DisableOption: OptionSet {
        
        let rawValue: UInt
        
        static let discard = DisableOption(rawValue: 1 << 0)
        static let save = DisableOption(rawValue: 1 << 1)
    }
}
