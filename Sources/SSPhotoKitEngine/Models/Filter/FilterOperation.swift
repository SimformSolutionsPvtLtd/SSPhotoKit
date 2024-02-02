//
//  FilterOperation.swift
//
//
//  Created by Krunal Patel on 04/01/24.
//

import CoreGraphics

public struct FilterOperation : Identifiable, Equatable {
    
    // MARK: - Vars & Lets
    public let name: String
    public var id: String { name }
    public var filter: AnyFilter
    public var previewImage: CGImage?
    
    // MARK: - Initializer
    public init<F: Filter>(filter: F, name: String, previewImage: CGImage? = nil) {
        self.filter = filter.asAny()
        self.name = name
        self.previewImage = previewImage
    }
}

extension FilterOperation {
    
    public static var original: FilterOperation {
        original(previewImage: nil)
    }
    
    public static func original(previewImage: CGImage? = nil) -> FilterOperation {
        FilterOperation(filter: .original, name: "Original", previewImage: previewImage)
    }
}
