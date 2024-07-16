//
//  PasswordKeys.swift
//  PasswordEncryption
//
//  Created by Ben Shutt on 17/10/2020.
//

import Foundation

/// Storable keys for password based encryption.
/// These keys are useless without the user's password so are not considered sensitive.
struct PasswordKeys: Model {

    /// Encrypted `k1`.
    /// This is decrypted using the user's password to become the AES key for encryption.
    var k4: [Byte]

    /// Second part of key created from user's password.
    /// First part is `k2` is used to AES encrypt `k1` to produce `k4`
    var k3: [Byte]

    /// Random data that is used as an additional input to a one-way function that
    /// hashes data, a password or passphrase.
    /// Salts are used to safeguard passwords in storage.
    var salt: [Byte]

    /// Initialization vector (IV) is a fixed-size input to a cryptographic primitive that is
    /// typically required to be random or pseudorandom.
    var iv: [Byte]
}
