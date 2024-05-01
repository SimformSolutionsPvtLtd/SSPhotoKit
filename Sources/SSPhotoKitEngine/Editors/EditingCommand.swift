//
//  File.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreImage

// MARK: - EditingCommand
public protocol EditingCommand : Hashable {
    
    var scale: CGSize { get set }
    
    func apply(to image: CIImage) async -> CIImage
}

extension EditingCommand {
    
    public var scale: CGSize {
        get {
            .one
        }
        set { }
    }
}

// MARK: - AnyEditingCommand
public struct AnyEditingCommand : EditingCommand {
    
    public let base: AnyHashable
//    public let type: (any EditingCommand).Type
    public var scale: CGSize {
        get {
            _getScale()
        }
        set {
            _setScale(newValue)
        }
    }
    
    private let _getScale: () -> CGSize
    private let _setScale: (CGSize) -> Void
    private let _apply: (CIImage) async -> CIImage
    
    init<E: EditingCommand>(_ editingCommand: E) {
        var copy = editingCommand
        base = copy
        
        _getScale = { copy.scale }
        _setScale = { value in copy.scale = value }
        _apply = { image in await copy.apply(to: image) }
    }
    
    public func apply(to image: CIImage) async -> CIImage {
        await _apply(image)
    }
    
    public static func == (lhs: AnyEditingCommand, rhs: AnyEditingCommand) -> Bool {
        lhs.base == rhs.base
    }
    
    public func hash(into hasher: inout Hasher) {
        base.hash(into: &hasher)
    }
    
    public func isType<T>(of: T.Type) -> Bool {
        return base is T
    }
}

extension EditingCommand {
    
    public func asAny() -> AnyEditingCommand {
        (self as? AnyEditingCommand) ?? AnyEditingCommand(self)
    }
}
