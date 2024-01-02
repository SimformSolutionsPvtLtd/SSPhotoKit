//
//  File.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//

import CoreImage

// MARK: - EditingCommand
public protocol EditingCommand : Hashable {
    
    func apply(to image: CIImage) async -> CIImage
}

// MARK: - AnyEditingCommand
public struct AnyEditingCommand : EditingCommand {
    
    public let base: AnyHashable
    private let _apply: (CIImage) async -> CIImage
    
    init<E: EditingCommand>(_ editingCommand: E) {
        base = editingCommand
        _apply = editingCommand.apply
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
}

extension EditingCommand {
    
    public func asAny() -> AnyEditingCommand {
        AnyEditingCommand(self)
    }
}
