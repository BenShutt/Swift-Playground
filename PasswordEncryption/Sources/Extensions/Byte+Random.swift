//
//  Byte+Random.swift
//  PasswordEncryption
//
//  Created by Ben Shutt on 17/10/2020.
//

import CryptoSwift
import Foundation

/// An 8-bit unsigned integer value
typealias Byte = UInt8

extension Byte {

    /// Generates an array of cryptographically secure random `Byte`s of length: `count`.
    ///
    /// - Parameter count: `Int` number of bytes
    static func random(count: Int) throws -> [Byte] {
        var bytes = [Byte](repeating: 0, count: count)
        let status = SecRandomCopyBytes(
            kSecRandomDefault,
            bytes.count,
            &bytes
        )

        guard status == errSecSuccess else {
            throw EncryptionError.failureStatus(status)
        }

        return bytes
    }
}
