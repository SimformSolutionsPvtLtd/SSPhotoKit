//
//  MultiEditingCommand.swift
//
//
//  Created by Krunal Patel on 04/01/24.
//

import CoreImage

public struct MultiEditingCommand : EditingCommand {
    
    public var scale: CGSize = .one {
        didSet {
            updateCommandsScale()
        }
    }
    public var commands: [AnyEditingCommand] = []
        
    public func apply(to image: CIImage) async -> CIImage {
        var copy = image
        
        await commands.asyncForEach() { command in
            copy = await command.apply(to: copy)
        }
        
        return copy
            .cropped(to: copy.extent)
    }
    
    private mutating func updateCommandsScale() {
        for i in commands.indices {
            commands[i].scale = scale
        }
    }
    
    public init<each C: EditingCommand>(_ commands: repeat each C) {
        repeat self.commands.append((each commands).asAny())
        updateCommandsScale()
    }
}
