//
//  Sequence+Extension.swift
//  SSPhotoKitEngine
//
//  Created by Krunal Patel on 04/01/24.
//

import CoreImage

extension Sequence where Element: EditingCommand {
    
    public func apply(to image: CIImage) async -> CIImage {
        var copy = image       
        await self.asyncForEach { command in
            copy = await command.apply(to: copy)
        }
        return copy
    }
}

extension Sequence where Element == any Filter {
    
    public func apply(to image: CIImage) async -> CIImage {
        var copy = image
        await self.asyncForEach { filter in
            copy = await filter.apply(to: copy)
        }
        return copy
    }
}

extension Sequence {
    
    @inlinable
    public func filterNot<T>(ofType type: T.Type) -> [Self.Element] {
        self.filter { !($0 is T) }
    }
}

extension Sequence {
    
    @inlinable
    public func asyncForEach(
        _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
}
