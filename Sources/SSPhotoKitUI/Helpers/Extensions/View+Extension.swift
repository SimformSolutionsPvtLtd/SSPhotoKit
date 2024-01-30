//
//  File.swift
//  
//
//  Created by Krunal Patel on 02/01/24.
//

import SwiftUI

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
