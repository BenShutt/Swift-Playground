//
//  PasswordEncryption.swift
//  PasswordEncryption
//
//  Created by Ben Shutt on 18/10/2020.
//

import CryptoSwift
import Foundation

/// Password based encryption using AES.
///
/// # How it works
///
/// - Step 1:
/// Generate a random key `k1` of length `randomKeyByteCount`.
/// Generate a random `IV` of length `randomIVByteCount`.
/// Generate a random `salt` of length `randomSaltByteCount`.
/// `k1` will be the key used to encrypt with AES.
/// We will encrypt `k1`, again with AES, with another key generated from the user's password.
///
/// - Step 2:
/// Use PBKDF2 (Password-Based Key Derivation Function 2) to generate a key of
/// length `PBKDF2ByteCount` from the password and salt.
/// Split this key into 2 keys `k2` and `k3`.
///
/// - Step 3:
/// Use AES with `k2` to encrypt `k1` using `IV` making `k4`.
///
/// - Step 4:
/// Save `k4`, `k3`, `salt`, and `iv`.
///
/// # Warning
/// Do not store `k2` anywhere. Do not store `k1` unencrypted.
/// Doing either of those things will break the security of the system.
///
/// # Future
/// Generate another key for HMAC to verify that the encrypted files haven't been tampered with.
/// We can generate a 128-bit HMAC key, and encrypt and store that with the main AES key.
struct PasswordEncryption {

    // MARK: - Static constants

    /// Number of bytes for the random key
    static let randomKeyByteCount = 16

    /// Number of bytes for the random IV
    static let randomIVByteCount = 16

    /// Number of bytes for the random salt
    static let randomSaltByteCount = 8

    /// Number of bytes for the PBKDF2 key from password and salt.
    static let pbkdf2ByteCount = 32

    /// Number of iterations for PBKDF2
    static let pbkdf2IterationCount = 1000 // 4096

    /// Algorithm's native output
    static let algorithm: HMAC.Variant = .sha2(.sha256)

    /// Convert password `String` to `Byte`s using this `String.Encoding`
    static let encoding: String.Encoding = .utf8

    // MARK: - Static functions

    /// Generate a random key
    private static func generateRandomKey() throws -> [Byte] {
        try Byte.random(count: randomKeyByteCount)
    }

    /// Generate a random IV
    private static func generateRandomIV() throws -> [Byte] {
        try Byte.random(count: randomIVByteCount)
    }

    /// Generate a random salt
    private static func generateRandomSalt() throws -> [Byte] {
        try Byte.random(count: randomSaltByteCount)
    }

    // MARK: - Instance properties

    /// `PasswordKeys` for password encryption
    private(set) var keys: PasswordKeys

    // MARK: - Init

    /// Initialize with `keys`
    /// 
    /// - Parameter keys: `PasswordKeys`
    init(keys: PasswordKeys) {
        self.keys = keys
    }

    /// Initialize a new instance, creating new `keys` for password based AES encryption
    /// for the given `password`
    ///
    /// - Parameter password: `String` User's password to generate keys for
    init(password: String) throws {
        // Step 1
        let k1 = try Self.generateRandomKey()
        let iv = try Self.generateRandomIV()
        let salt = try Self.generateRandomSalt()

        // Step 2
        let k2k3 = try Self.pbkdf2AndSplit(password: password, salt: salt)

        // Step 3
        let keyAES = try AES(key: k2k3.k2, gcmIV: iv)
        let k4 = try keyAES.encrypt(k1)

        // Step 4
        self.keys = PasswordKeys(
            k4: k4,
            k3: k2k3.k3,
            salt: salt,
            iv: iv
        )
    }

    /// Use `PBKDF2` with the given `password` and `salt` to generated `K2K3`
    ///
    /// - Parameters:
    ///   - password: `String` password
    ///   - salt: `[Byte]` salt
    private static func pbkdf2AndSplit(
        password: String,
        salt: [Byte]
    ) throws -> K2K3 {
        let passwordBytes = try password.dataOrThrow(encoding: encoding).bytes
        let pbkdf2 = try PKCS5.PBKDF2(
            password: passwordBytes,
            salt: salt,
            iterations: pbkdf2IterationCount,
            keyLength: pbkdf2ByteCount,
            variant: algorithm
        )
        return try K2K3(key: pbkdf2.calculate())
    }

    /// `AES` using `PBKDF2` with the given `password` and `keys`
    ///
    /// - Parameters:
    ///   - password: `String`
    private func aesKeys(with password: String) throws -> AESKeys {
        let k2k3 = try Self.pbkdf2AndSplit(password: password, salt: keys.salt)
        guard k2k3.k3 == keys.k3 else {
            throw EncryptionError.k3NotEqual
        }

        // AES key
        let keyAES = try AES(key: k2k3.k2, gcmIV: keys.iv)
        let k1 = try keyAES.decrypt(keys.k4)

        return AESKeys(
            k1: k1,
            k2k3: k2k3
        )
    }

    /// Encrypt `data` with `password`
    ///
    /// - Note:
    /// The `IV` should not be recycled, so if `Data` is re-encrypted we should
    /// generate a new `IV`
    /// Note the `IV` is used to make `k4` by `AES` encrypting `k1` with`k2`.
    /// So this also updates `k4`
    ///
    /// - Parameters:
    ///   - data: `Data`
    ///   - password: `String`
    mutating func encrypt(
        data: Data,
        with password: String
    ) throws -> Data {
        let aesKeys = try self.aesKeys(with: password)

        // Update IV on (local) keys
        var newKeys = keys
        newKeys.iv = try Self.generateRandomIV()

        // Generate new k4 from new IV
        let keyAES = try AES(key: aesKeys.k2k3.k2, gcmIV: newKeys.iv)
        let newK4 = try keyAES.encrypt(aesKeys.k1)
        newKeys.k4 = newK4

        // Create `AES` and encrypt data
        let data = try aesKeys.aes(iv: newKeys.iv)
            .encrypt(data.bytes)
            .data

        // Commit new keys
        keys = newKeys
        return data
    }

    /// Decrypt `data` with `password`
    ///
    /// - Parameters:
    ///   - data: `Data`
    ///   - password: `String`
    func decrypt(data: Data, with password: String) throws -> Data {
        // Create `AES` and decrypt data
        try aesKeys(with: password)
            .aes(iv: keys.iv)
            .decrypt(data.bytes)
            .data
    }
}
