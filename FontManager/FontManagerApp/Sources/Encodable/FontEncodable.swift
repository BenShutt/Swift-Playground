//
//  FontEncodable.swift
//  FontManager
//
//  Created by Ben Shutt on 22/02/2020.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation

/// Methods that should be implemented in a subclass of `FontEncodable`
protocol FontEncodable {
    associatedtype E: Encodable
    
    /// Name for the `PropertyList` file to write to.
    func plistName() -> String
    
    /// Return an `Encodable` `E`
    func encodable() throws -> E
}

/// A class that given a `FontDirectory` can write a plist file via encoding
/// an `Encodable` `T`
class FontEncodableBase<T>: FontEncodable where T: Encodable {
    typealias E = T
    
    /// `FontDirectory` passed on initializer
    let directory: FontDirectory
    
    /// Initialize with the given`fontDirectory`
    /// - Parameter fontDirectory: `FontDirectory`
    init (directory: FontDirectory) {
        self.directory = directory
    }
    
    /// Default implementation provided
    func plistName() -> String {
        return directory.fontName
    }
    
    /// Subclasses must implement
    func encodable() throws -> T {
        fatalError("Not implemented")
    }
    
    /// Write the encoded `PropertyList` file in `directroy` with the name `plistName()`
    func write() throws {
        let extn = ".\(Constants.propertyListExtension)"
        let filename = plistName().suffixingIfRequired(extn)
        let url = directory.fontDirectory.appendingPathComponent(filename)
        try PropertyList.write(encodable: encodable(), to: url)
    }
}
