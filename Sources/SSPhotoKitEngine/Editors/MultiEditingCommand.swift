//
//  MultiEditingCommand.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 04/01/24.
//

import CoreImage

/// Combine multiple editing command as one.
public struct MultiEditingCommand: EditingCommand {
    
    // MARK: - Vars & Lets
    public var scale: CGSize = .one {
        didSet {
            updateCommandsScale()
        }
    }
    
    /// List of commands.
    public var commands: [AnyEditingCommand] = []
        
    // MARK: - Methods
    public func apply(to image: CIImage) async -> CIImage {
        var copy = image
        
        await commands.asyncForEach { command in
            copy = await command.apply(to: copy)
        }
        
        return copy
            .cropped(to: copy.extent)
    }
    
    private mutating func updateCommandsScale() {
        for index in commands.indices {
            commands[index].scale = scale
        }
    }
    
    // MARK: - Initializer
    public init<each C: EditingCommand>(_ commands: repeat each C) {
        repeat self.commands.append((each commands).asAny())
        updateCommandsScale()
    }
}
