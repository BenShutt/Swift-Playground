//
//  EncryptedData.swift
//  PasswordEncryption
//
//  Created by Ben Shutt on 31/10/2020.
//

import Foundation

/// Encrypted data to send to server containing the user's passwords
struct EncryptedData {

    /// IV for `GCM` to AES encrypt
    var iv: [Byte]

    /// Salt for user's password
    var salt: [Byte]

    /// Key (hash) to verify if a user's password is correct
    /// -  TODO: Might use to sign
    var k3: [Byte]

    /// The encrypted `Data` 
    var data: Data
}
