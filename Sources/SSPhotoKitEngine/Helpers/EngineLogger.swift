//
//  File.swift
//  
//
//  Created by Krunal Patel on 02/01/24.
//

import os

// MARK: - EngineLogger
enum EngineLogger {
    
    private static let logger = Logger(subsystem: "SSPhotoKit", category: "SSPhotoKitEngine")
    
    static func info(_ items: Any...,
                     separator: String = " ") {
        #if DEBUG
            logger.info("\(items.asString(separator: separator))")
        #endif
    }
    
    static func debug(_ items: Any...,
                      separator: String = " ") {
        #if DEBUG
            logger.debug("\(items.asString(separator: separator))")
        #endif
    }
    
    static func warning(_ items: Any...,
                        separator: String = " ") {
        logger.warning("\(items.asString(separator: separator))")
    }
    
    static func error(_ items: Any...,
                      separator: String = " ") {
        logger.error("\(items.asString(separator: separator))")
    }
}

extension Sequence where Element == Any {
    
    fileprivate func asString(separator: String = " ") -> String {
        self.map { "\($0)" }.joined(separator: separator)
    }
}
