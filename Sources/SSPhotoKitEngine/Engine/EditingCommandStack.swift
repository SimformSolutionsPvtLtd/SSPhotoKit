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


struct EditingCommandStack2 : Hashable {
    
    private(set) var commands: [any EditingCommand] = []
    
    var isEmpty: Bool { commands.isEmpty }
    
    // TODO: make generic
    mutating func push(_ command: any EditingCommand) {
        commands.append(command)
    }
    
    mutating func push(contentOf commands: [AnyEditingCommand]) {
        self.commands.append(contentsOf: commands)
    }
    
    mutating func pop() ->  any EditingCommand {
        commands.removeLast()
    }
    
    mutating func peek() -> (any EditingCommand)? {
        commands.last
    }
    
    mutating func removeAll() {
        commands.removeAll()
    }
    
    static func == (lhs: EditingCommandStack2, rhs: EditingCommandStack2) -> Bool {
        lhs.commands.map { $0.asAny() } == rhs.commands.map { $0.asAny() }
    }
    
    func hash(into hasher: inout Hasher) {
        commands.map { $0.asAny() }.hash(into: &hasher)
    }
}

