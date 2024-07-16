//
//  EncryptionError.swift
//  PasswordEncryption
//
//  Created by Ben Shutt on 17/10/2020.
//

import Foundation

/// `Error`s that can be thrown in `Encryption`
enum EncryptionError: Error {

    /// Status returned cryptography function was not successful
    case failureStatus(_ status: Int32)

    /// k3 didn't match, either password is wrong, or someone tampered with file/keys
    case k3NotEqual

    /// Failed to get public key from private key.
    /// 
    /// I.e. `SecKeyCopyPublicKey` returns `nil` when getting a publicKey for a privateKey.
    case publicKey

    /// The given `SecKeyAlgorithm` is not supported
    case unsupportedAlgorithm(SecKeyAlgorithm)
}
