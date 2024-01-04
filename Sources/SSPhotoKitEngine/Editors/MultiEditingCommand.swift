//
//  MultiEditingCommand.swift
//
//
//  Created by Krunal Patel on 04/01/24.
//

import CoreImage

public struct MultiEditingCommand : EditingCommand {
    
    public var commands: [AnyEditingCommand] = []
        
    public func apply(to image: CIImage) async -> CIImage {
        var copy = image
        
        await commands.asyncForEach() { command in
            copy = await command.apply(to: copy)
        }
        
        return copy
            .cropped(to: copy.extent)
    }
    
    public init<each C: EditingCommand>(_ commands: repeat each C) {
        repeat self.commands.append((each commands).asAny())
    }
}
