//
//  String+Data.swift
//  PasswordEncryption
//
//  Created by Ben Shutt on 16/07/2024.
//

import Foundation

// MARK: - StringError

/// An `Error` converting from `String` to `Data` or vice versa
enum StringDataError: Error {

    /// Failed to create a `String` from the given `Data` and `String.Encoding`
    case data(Data, encoding: String.Encoding)

    /// Failed to create `Data` from the given `String` and `String.Encoding`
    case string(String, encoding: String.Encoding)
}

// MARK: - String + Data

extension String {

    /// `String` instance to `Data` or `throw`
    /// - Parameter encoding: `String.Encoding`
    func dataOrThrow(encoding: String.Encoding) throws -> Data {
        guard let data = data(using: encoding) else {
            throw StringDataError.string(self, encoding: encoding)
        }
        return data
    }
}

// MARK: - Data + String

extension Data {

    /// `Data` instance to `String` or `throw`
    /// - Parameter encoding: `String.Encoding`
    func stringOrThrow(encoding: String.Encoding) throws -> String {
        guard let string = String(data: self, encoding: encoding) else {
            throw StringDataError.data(self, encoding: encoding)
        }
        return string
    }
}
