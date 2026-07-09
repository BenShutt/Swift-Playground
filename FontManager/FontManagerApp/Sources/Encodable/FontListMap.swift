//
//  File.swift
//  
//
//  Created by Ben Shutt on 22/02/2020.
//

import Foundation

// MARK: - FontList

/// Array of font names
typealias FontList = [String]

final class FontListEncodable: FontEncodableBase<FontList> {
    
    /// Use the `FontConfiguration.shared.infoFileName`
    override func plistName() -> String {
        return "\(FontConfiguration.shared.infoFileName)"
    }
    
    /// `FontList` from the given `fontDirectory`
    ///
    /// - Parameter directory: `FontDirectory`
    override func encodable() throws -> FontList {
        return directory.fontFiles.map { $0.lastPathComponent }
    }
}

// MARK: - FontListMap

/// Map `Info.plist` fonts key to an array of font names
typealias FontListMap = [String : FontList]

/// Write a plist file which lists all the custom app fonts 
final class FontListMapping: FontEncodableBase<FontListMap> {
    
    /// See `FontListEncodable`
    override func plistName() -> String {
        return FontListEncodable(directory: directory).plistName()
    }
    
    /// `FontListMap` from the given `fontDirectory`
    ///
    /// - Parameter directory: `FontDirectory`
    override func encodable() throws -> FontListMap {
        let value = try FontListEncodable(directory: directory).encodable()
        return [Constants.fontsKey : value]
    }
}
