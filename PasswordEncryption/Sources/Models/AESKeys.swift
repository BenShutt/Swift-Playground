//
//  AESKeys.swift
//  PasswordEncryption
//
//  Created by Ben Shutt on 31/10/2020.
//

import CryptoSwift
import Foundation

/// `k1` is the key used for `AES` encryption, which is itself `AES` encrypted using
/// `k2` generated from the user's password creating (encrypted) `k4`.
///
/// - Warning:
/// This structure should **not** be stored and is considered sensitive.
struct AESKeys {

    /// Key to AES encrypt data
    var k1: [Byte]

    /// `K2K3` two halves of the hash of the user's password
    /// - `k2` is used to AES encrypt `k1` to make `k4`
    /// - `k3` is simply to verify if the password is correct
    var k2k3: K2K3

    /// `AES` using key `k1` and the given `iv`
    ///
    /// - Parameter iv: `[Byte]`
    func aes(iv: [Byte]) throws -> AES {
        try AES(key: k1, gcmIV: iv)
    }
}
