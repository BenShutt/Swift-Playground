//
//  PropertyList.swift
//  FontManager
//
//  Created by Ben Shutt on 06/12/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation

/// An `Error` in `PropertyList`
enum PropertyListError: Error {
    
    /// `PropertyList` file was not found
    case fileNotFound
}

/// Read and write property list files from `Decodable` and `Encodable` respectively
final class PropertyList {
    
    /// Encode `encodable` into `PropertyList` data and write to the given `url`.
    /// - Parameter url: `URL` to write to
    static func write<T>(encodable: T, to url: URL) throws where T: Encodable {
        let data = try PropertyListEncoder().encode(encodable)
        try data.write(to: url, options: .atomicWrite)
    }
    
    /// Decode `T` from`PropertyList` data at the given `url` and return an instance of `T`.
    /// - Parameter url: `URL` to read from
    static func read<T>(from url: URL) throws -> T where T: Decodable {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw PropertyListError.fileNotFound
        }
        let data = try Data(contentsOf: url)
        return try PropertyListDecoder().decode(T.self, from: data)
    }
}


