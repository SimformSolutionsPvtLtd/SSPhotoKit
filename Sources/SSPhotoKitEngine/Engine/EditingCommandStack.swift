//
//  EditingCommandStack.swift
//
//
//  Created by Krunal Patel on 02/01/24.
//

struct EditingCommandStack : Hashable {
    
    private(set) var commands: [AnyEditingCommand] = []
    
    var isEmpty: Bool { commands.isEmpty }
    
    // TODO: make generic
    mutating func push(_ command: AnyEditingCommand) {
        commands.append(command)
    }
    
    mutating func push(contentOf commands: [AnyEditingCommand]) {
        self.commands.append(contentsOf: commands)
    }
    
    mutating func pop() -> AnyEditingCommand {
        commands.removeLast()
    }
    
    mutating func peek() -> AnyEditingCommand? {
        commands.last
    }
    
    mutating func removeAll() {
        commands.removeAll()
    }
}
