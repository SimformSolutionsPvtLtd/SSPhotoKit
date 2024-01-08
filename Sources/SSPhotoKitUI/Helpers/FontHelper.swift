//
//  FontHelper.swift
//
//
//  Created by Krunal Patel on 04/01/24.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

enum FontHelper {
    
    #if os(iOS)
    static let fontFamilies = UIFont.familyNames
    
    static func fonts(for family: String) -> [String] {
        UIFont.fontNames(forFamilyName: family)
    }
    
    static var fontsWithFamily: [String : String] {
        [:]
    }
    
    #elseif os(macOS)
    private static var fontManager: NSFontManager { NSFontManager.shared }
    static let fontFamilies = fontManager.availableFontFamilies
    
    static func fonts(for family: String) -> [String] {
        //        fontManager.availableMembers(ofFontFamily: family)?.compactMap({ member in
        //            member
        //        })
        fontManager.availableFonts
            .filter {
                $0.starts(with: family.replacingOccurrences(of: " ", with: ""))
            }
    }
    #endif
    
}
