//
//  FilterConfiguration.swift
//  SSPhotoKit
//
//  Created by Krunal Patel on 16/01/24.
//

import SwiftUI
#if canImport(SSPhotoKitEngine)
import SSPhotoKitEngine
#endif

public struct FilterConfiguration {
    
    // MARK: - Vars & Lets
    public var customFilterGroups: GroupedFilters
    
    public var filterOptions: FilterOptions
    
    public var defaultFilterGroups: GroupedFilters = LUTLoader.loadAll()

    public var filterGroups: GroupedFilters {
        switch filterOptions {
        case .custom:
            customFilterGroups
        case .default:
            defaultFilterGroups
        case .all:
            defaultFilterGroups + customFilterGroups
        default:
            [:]
        }
    }
    
    // MARK: - Initializer
    public init(customFilterGroups: GroupedFilters = [:],
                filterOptions: FilterOptions = .all) {
        self.customFilterGroups = customFilterGroups
        self.filterOptions = filterOptions
    }
}

// MARK: - Options
extension FilterConfiguration {
    
    public struct FilterOptions: OptionSet {
        
        public var rawValue: UInt32
        
        public static let natural = FilterOptions(rawValue: 1 << 0)
        
        public static let `default` = FilterOptions(rawValue: 1 << 1)
        
        public static let custom = FilterOptions(rawValue: 1 << 2)
        
        public static let all: FilterOptions = [.natural, .default, .custom]
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
    }
}
