//
//  File.swift
//  
//
//  Created by Krunal Patel on 04/01/24.
//

#if os(macOS)
import AppKit

extension NSView {
    
    public func setNeedsDisplay() {
        needsDisplay = true
    }
}
#endif
