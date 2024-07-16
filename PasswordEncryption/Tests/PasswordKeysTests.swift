//
//  PasswordKeysTests.swift
//  PasswordEncryptionTests
//
//  Created by Ben Shutt on 16/07/2024.
//

import Foundation

@testable import PasswordEncryption
import XCTest

class PasswordKeysTests: XCTestCase {
    func test() throws {
        // TODO
    }

    /// Given `encryptedData` from server. Read `PasswordKeys` from file and
    /// decrypt using the given `password`
    ///
    /// - Parameters:
    ///   - encryptedData: `Data`
    ///   - password: `String`
    private func decryptData(
        _ encryptedData: Data,
        with password: String
    ) throws -> [Password] {

        // Get `PasswordKeys`
        let keys = try PasswordKeysFile.read()
        
        // Create a `PasswordEncryption` from `PasswordKeys`
        let encryption = PasswordEncryption(keys: keys)
        
        // Use `PasswordEncryption` to decrypt the given `encryptedData`
        let decryptedData = try encryption.decrypt(
            data: encryptedData,
            with: password
        )
        
        // Decode `decryptedData` into passwords
        return try JSONDecoder().decode(
            [Password].self,
            from: decryptedData
        )
    }
    
    /// Remove any application files/storage
    private func clean() {
        try? PasswordKeysFile.remove()
        // Remove `Credentials` from keychain
    }
}

// MARK: - Password

/// A user password
private struct Password: Model {

    /// `UUID` of the `Password`
    var id: UUID

    /// Name of the `Password`
    var name: String

    /// Username of the `Password`
    var username: String

    /// The password of the `Password`
    var password: String

    /// `Date` the `Password` was created
    var dateCreated: Date

    /// Optional notes of the `Password`
    var notes: String?
}
