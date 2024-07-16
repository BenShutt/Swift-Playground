//
//  KeyPair.swift
//  PasswordEncryption
//
//  Created by Ben Shutt on 01/11/2020.
//

import Foundation

/// A public, private key pair for asymmetric encryption
struct KeyPair {

    /// `SecKey` corresponding private key
    var privateKey: SecKey

    /// `SecKey` corresponding public key
    var publicKey: SecKey

    /// Default memberwise initializer
    ///
    /// - Parameters:
    ///   - privateKey: `SecKey`
    ///   - publicKey: `SecKey`
    init(
        privateKey: SecKey,
        publicKey: SecKey
    ) {
        self.privateKey = privateKey
        self.publicKey = publicKey
    }
}

// MARK: - Extensions

extension KeyPair {

    /// Generate a new private key and get the corresponding public key
    ///
    /// - Parameters:
    ///   - keyType: `CFString` to define `kSecAttrKeyType` when creating a private key
    ///   - keyByteCount: Size of the key in bytes
    ///
    /// - Throws: `Error` when creating public, private key pair
    init(
        keyType: CFString = kSecAttrKeyTypeRSA,
        keyByteCount: Int = 256
    ) throws {
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: keyType,
            kSecAttrKeySizeInBits as String: keyByteCount * .nBitsInByte
        ]

        var error: Unmanaged<CFError>!
        guard let privateKey: SecKey = SecKeyCreateRandomKey(
            attributes as CFDictionary,
            &error
        ) else {
            throw error.takeRetainedValue() as Error
        }

        // Get the public key from the private key
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            throw EncryptionError.publicKey
        }

        self.init(
            privateKey: privateKey,
            publicKey: publicKey
        )
    }
}
