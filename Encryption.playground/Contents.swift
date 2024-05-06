import Foundation
import CryptoKit

/// AES-GCM encryption using CryptoKit
struct AESEncryption {

    /// A Base64 encoded string of a byte sequence
    typealias Base64String = String

    /// The secret symmetric key to use for encryption and decryption.
    /// Defaults to a new 256 bit key
    var key = SymmetricKey(size: .bits256)

    /// Base64 encoded string representation of the key
    var base64EncodedKey: Base64String {
        key.withUnsafeBytes { bytes in
            Data(Array(bytes)).base64EncodedString()
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
    /// - Parameter base64EncodedString: Base64 encoded string to decrypt
    /// - Returns: Decrypted data mapped (back) to a string
    func decrypt(base64EncodedString: Base64String) throws -> String {
        try String(
            decoding: decrypt(data: base64EncodedString.data),
            as: UTF8.self
        )
    }
}

// MARK: - AESEncryption + Init

extension AESEncryption {
    
    /// Initialize with a 256 bit Base64 encoded string
    /// - Parameter key: Base64 encoded string representation of the 256 bit key
    init(base64EncodedKey: Base64String) throws {
        key = try SymmetricKey(data: base64EncodedKey.data)
    }
}

// MARK: - AESEncryption.Base64String + Extensions

private extension AESEncryption.Base64String {

    /// Map a Base64 encoded string to data
    var data: Data {
        get throws {
            if let data = Data(base64Encoded: self) {
                data
            } else {
                throw AESEncryptionError.base64
            }
        }
    }
}

// MARK: - AESEncryptionError

/// An `Error` that may be thrown in `AESEncryption`
enum AESEncryptionError: Error {

    /// Error thrown if the combined after encrypting is `nil`
    case combined

    /// Error thrown if the data from a Base64 encoded String is `nil`
    case base64
}

// MARK: - Main

// Log the duration of the encryption and decryption
let startDate = Date()
defer {
    let endDate = Date()
    print("Elapsed time \(endDate.timeIntervalSince(startDate))s")
}

do {
    // Make an AESEncryption instance with a new secret key
    var aes = AESEncryption()
    print("AES encryption key \(aes.base64EncodedKey)")

    // Encrypt and decrypt the sample data
    let value = "Some sensitive data that should be encrypted"
    let encrypted = try aes.encrypt(string: value)
    let decrypted = try aes.decrypt(base64EncodedString: encrypted)

    // Check the output matches the input
    print("Encryption success: \(value == decrypted)")

    // Test a pre-defined key
    let key = "AJULtMh8ryb3gWEvOjbhYYOqcFJw3TYODnR4pZZhMMM="
    aes = try AESEncryption(base64EncodedKey: key)
    print("Key success: \(aes.base64EncodedKey == key)")
} catch {
    print("Error: \(error)")
}

// References:
// - https://developer.apple.com/documentation/cryptokit/performing_common_cryptographic_operations
// - https://medium.com/@garg.vivek/a-comprehensive-guide-to-using-the-crypto-framework-with-swift-341a2ccfc08f
// - https://stackoverflow.com/a/41650903/5024990
// - https://stackoverflow.com/a/43817935
