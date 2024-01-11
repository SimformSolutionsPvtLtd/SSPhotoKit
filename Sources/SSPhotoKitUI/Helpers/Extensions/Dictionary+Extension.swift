//
//  Dictionary+Extension.swift
//  SSPhotoKitUI
//
//  Created by Krunal Patel on 16/01/24.
//

import Foundation

extension Dictionary {
    
    static func +=(lhs: inout Self, rhs: Self) {
        lhs.merge(rhs) { _ , new in new }
    }
    
    static func +=<S: Sequence>(lhs: inout Self, rhs: S) where S.Element == (Key, Value) {
        lhs.merge(rhs) { _ , new in new }
    }
    
    static func +(lhs: Dictionary, rhs: Dictionary) -> Dictionary {
        lhs.merging(rhs) { (current, _) in current }
    }
}
