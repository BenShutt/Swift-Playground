import Foundation
import CryptoKit

/// AES-GCM encryption using CryptoKit
struct AESEncryption {

    /// A Base64 encoded string
    typealias Base64String = String

    /// The secret symmetric key to use for encryption and decryption
    /// Defaults to a new 256 bit key
    var key = SymmetricKey(size: .bits256)

    /// Base64 encoded string representation of the key
    var stringKey: Base64String {
        key.withUnsafeBytes {
            Data(Array($0)).base64EncodedString()
        }
    }

    // MARK: - Data

    /// Encrypt the given data
    /// - Parameter data: The data to encrypt
    /// - Returns: The encrypted data
    func encrypt(data: Data) throws -> Data {
        let sealedBox = try AES.GCM.seal(data, using: key)
        guard let combined = sealedBox.combined else {
            throw AESEncryptionError.combined
        }
        return combined
    }

    /// Decrypt the given data
    /// - Parameter data: The data to decrypt
    /// - Returns: The decrypted data
    func decrypt(data: Data) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        return try AES.GCM.open(sealedBox, using: key)
    }

    // MARK: - String

    /// Encrypt the given string returning a Base64 encoded string representation
    /// - Note: The encrypted data is a binary blob, and in most cases not a valid UTF-8 sequence
    /// - Parameter string: String to encrypt
    /// - Returns: Base64 encoded string representation of the encrypted data
    func encrypt(string: String) throws -> Base64String {
        try encrypt(data: Data(string.utf8)).base64EncodedString()
    }

    /// Decrypt the given Base64 encoded string representation of encrypted data
    /// - Parameter string: Base64 encoded string to decrypt
    /// - Returns: Decrypted data mapped (back) to a string
    func decrypt(base64Encoded string: Base64String) throws -> String {
        guard let data = Data(base64Encoded: string) else {
            throw AESEncryptionError.base64
        }
        return try String(
            decoding: decrypt(data: data),
            as: UTF8.self
        )
    }
}

// MARK: - AESEncryption + Init

extension AESEncryption {
    
    /// Initialize with a 256 bit Base64 encoded string
    /// - Parameter key: Base64 encoded string representation of the 256 bit key
    init(key: Base64String) throws {
        guard let data = Data(base64Encoded: key) else {
            throw AESEncryptionError.base64
        }
        self.key = SymmetricKey(data: data)
    }
}

// MARK: - AESEncryptionError

/// An `Error` that may be thrown in `AESEncryption`
enum AESEncryptionError: Error {

    /// Data from Base64 encoded String was `nil`
    case base64

    /// After encrypting, combined was `nil`
    case combined
}

// MARK: - Main

// Log the duration of the encryption and decryption
let startDate = Date()
defer {
    let endDate = Date()
    print("Elapsed time \(endDate.timeIntervalSince(startDate))s")
}

do {
    // Make a new secret key
    let aes = AESEncryption()
    print("AES encryption key \(aes.stringKey)")

    // Encrypt and decrypt the data
    let value = "Some sensitive data that should be encrypted"
    let encrypted = try aes.encrypt(string: value)
    let decrypted = try aes.decrypt(base64Encoded: encrypted)

    // Check the output matches the input
    let valueMatches = value == decrypted
    print("Success: \(valueMatches)")
} catch {
    print(error)
}

// References:
// - https://developer.apple.com/documentation/cryptokit/performing_common_cryptographic_operations
// - https://medium.com/@garg.vivek/a-comprehensive-guide-to-using-the-crypto-framework-with-swift-341a2ccfc08f
// - https://stackoverflow.com/a/41650903/5024990
// - https://stackoverflow.com/a/43817935
