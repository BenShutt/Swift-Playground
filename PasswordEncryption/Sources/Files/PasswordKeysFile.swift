//
//  PasswordKeysFile.swift
//  PasswordEncryption
//
//  Created by Ben Shutt on 18/10/2020.
//

import Foundation

/// File for storing the `PasswordKeys`
struct PasswordKeysFile {

    /// `FileManager.SearchPathDirectory` to save file in
    private static let searchPathDirectory =
        FileManager.SearchPathDirectory.applicationSupportDirectory

    /// Name of the file
    private static let filename = "passwordKeys.json"

    /// `URL` location of the file
    static func url() throws -> URL {
        try FileManager.default.url(
            for: searchPathDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        .appendingPathComponent(filename)
    }

    /// Read `Data` from `url()` and decode into `PasswordKeys`
    static func read() throws -> PasswordKeys {
        let data = try Data(contentsOf: url())
        return try JSONDecoder().decode(PasswordKeys.self, from: data)
    }

    /// Remove file at `url()`
    static func remove() throws {
        try FileManager.default.removeItem(at: url())
    }
}
