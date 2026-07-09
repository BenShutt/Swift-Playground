//
//  Console.swift
//  App
//
//  Created by Ben Shutt on 08/12/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation

enum OutputType {
    
    /// Standard output
    case standard
    
    /// Error output
    case error
}

/// Command line console utility
final class Console {
    
    /// Executable name
    static let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
    
    /// Write a `message` on the given `OutputType`
    static func write(_ message: String, to output: OutputType = .standard) {
        switch output {
        case .standard:
            print(message) // By default writes to `stdout`
        case .error:
            fputs("[ERROR]: \(message)\n", stderr)
        }
    }
}
