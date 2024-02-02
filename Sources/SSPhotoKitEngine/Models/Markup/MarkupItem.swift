//
//  MarkupItem.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 08/01/24.
//

import CoreGraphics
import Foundation

// MARK: -  MarkupItem
public protocol MarkupItem : Identifiable, Hashable {
    
    var id: String { get }
    
    var size: CGSize { get set }
    var origin: CGPoint { get set }
    var rotation: CGFloat { get set }
    var scale: CGSize { get set }
    
    mutating func updateScale(_ scale: CGSize)
}

// MARK: - MarkupItem Defaults
extension MarkupItem {
    
    public var id: String { UUID().uuidString }
    
    public var scale: CGSize {
        get {
            CGSize(width: 1, height: 1)
        }
        set { }
    }
    
    public mutating func updateScale(_ scale: CGSize) { }
    
    public mutating func resetScale() {
        updateScale(CGSize(width: 1, height: 1))
    }
    
    public mutating func updateExtent() {
        size *= scale
        origin.x *= scale.width
        origin.y *= scale.height
    }
}

// MARK: - AnyMarkupItem
public struct AnyMarkupItem : MarkupItem {
    
    // MARK: - Vars & Lets
    private let base: AnyHashable
    public let id: String
    
    public var size: CGSize {
        get { _getSize() }
        set { _setSize(newValue) }
    }
    public var origin: CGPoint {
        get { _getOrigin() }
        set { _setOrigin(newValue) }
    }
    public var rotation: CGFloat {
        get { _getRotation() }
        set { _setRotation(newValue) }
    }
    public var scale: CGSize {
        get { _getScale() }
        set { _setScale(newValue) }
    }
    
    // MARK: - Closures
    private let _updateScale: (CGSize) -> Void
    private let _getSize: () -> CGSize
    private let _setSize: (CGSize) -> Void
    
    private let _getOrigin: () -> CGPoint
    private let _setOrigin: (CGPoint) -> Void
    
    private let _getRotation: () -> CGFloat
    private let _setRotation: (CGFloat) -> Void
    
    private let _getScale: () -> CGSize
    private let _setScale: (CGSize) -> Void
    
    
    // MARK: - Initializer
    public init<M: MarkupItem>(_ markupItem: M) {
        var copy = markupItem
        base = copy
        id = markupItem.id
        _getSize = { copy.size }
        _setSize = { value in copy.size = value }
        _getOrigin = { copy.origin }
        _setOrigin = { value in copy.origin = value }
        _getRotation = { copy.rotation }
        _setRotation = { value in copy.rotation = value }
        _getScale = { copy.scale }
        _setScale = { value in copy.scale = value }
        
        _updateScale = { scale in copy.updateScale(scale) }
    }
    
    // MARK: - Methods
    public func updateScale(_ scale: CGSize) {
        _updateScale(scale)
    }
    
    public static func == (lhs: AnyMarkupItem, rhs: AnyMarkupItem) -> Bool {
        lhs.base == rhs.base
    }
    
    public func hash(into hasher: inout Hasher) {
        base.hash(into: &hasher)
    }
}

extension MarkupItem {
    public func asAny() -> AnyMarkupItem {
        (self as? AnyMarkupItem) ?? AnyMarkupItem(self)
    }
}
