//
//  FooterMenu.swift
//
//
//  Created by Krunal Patel on 04/01/24.
//

import SwiftUI

struct FooterMenu: View {
    
    let title: String
    let disableOptions: DisableOption
    let onSave: () -> Void
    let onDiscard: () -> Void
    
    var body: some View {
        
        HStack {
            Button {
                onDiscard()
            } label: {
                Image(systemName: "xmark")
            }
            .buttonStyle(.primary)
            .foregroundStyle(disableOptions.contains(.discard) ? .gray : .white)
            .disabled(disableOptions.contains(.discard))
            
            Spacer()
            
            Text(title)
            
            Spacer()
            
            
            Button {
                onSave()
            } label: {
                Image(systemName: "checkmark")
            }
            .buttonStyle(.primary)
            .foregroundStyle(disableOptions.contains(.save) ? .gray : .white)
            .disabled(disableOptions.contains(.save))
            
        }
        .font(.system(.headline, weight: .medium))
        .padding(.horizontal, 24)
        .background(.black)
    }
    
    init(_ title: String, disableOptions: DisableOption = [], onSave: @escaping () -> Void, onDiscard: @escaping () -> Void) {
        self.title = title
        self.disableOptions = disableOptions
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
