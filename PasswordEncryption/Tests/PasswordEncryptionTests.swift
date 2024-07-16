//
//  PasswordEncryptionTests.swift
//  PasswordEncryptionTests
//
//  Created by Ben Shutt on 18/10/2020.
//

@testable import PasswordEncryption
import XCTest

/// Test `PasswordEncryption`
class PasswordEncryptionTests: XCTestCase {

    /// A test password
    private let password = "Password-test_123!"

    /// A password which is not `password`
    private lazy var invalidPassword = "invalid" + password

    /// A `String` to encrypt and decrypt
    private let stringToEncrypt = "Welcome to \(PasswordEncryptionTests.self)"

    // MARK: - Tests

    /// Create multiple `PasswordEncryption` instances from the same `password`
    /// Ensure random keys are different.
    /// `k3` is generated from the same password, but uses a different salt
    func test_randomKey() throws {
        // Create `PasswordEncryption`
        let p1 = try PasswordEncryption(password: password)

        // Create another `PasswordEncryption`
        let p2 = try PasswordEncryption(password: password)

        // Valid password
        XCTAssertNotEqual(p1.keys.k4, p2.keys.k4)
        XCTAssertNotEqual(p1.keys.k3, p2.keys.k3)
        XCTAssertNotEqual(p1.keys.salt, p2.keys.salt)
        XCTAssertNotEqual(p1.keys.iv, p2.keys.iv)

        // Invalid password
        let p3 = try PasswordEncryption(password: invalidPassword)
        XCTAssertNotEqual(p1.keys.k4, p3.keys.k4)
        XCTAssertNotEqual(p1.keys.k3, p3.keys.k3)
        XCTAssertNotEqual(p1.keys.salt, p3.keys.salt)
        XCTAssertNotEqual(p1.keys.iv, p3.keys.iv)
    }

    /// 1. Generate keys
    /// 2. Encrypt a test `String` creating encrypted `Data`
    /// 3. Decrypt the encrypted `Data` creating decrypted `String`
    /// 4. Assert test `String` equals decrypted `String`
    func test_passwordEncryption() throws {
        // Create `PasswordEncryption`
        var pEncryption = try PasswordEncryption(password: password)

        // Encrypt
        let encryptedData = try pEncryption.encrypt(
            string: stringToEncrypt,
            with: password
        )

        // Decrypt
        let decryptedString: String = try pEncryption.decrypt(
            data: encryptedData,
            with: password
        )

        // Assert
        XCTAssertEqual(stringToEncrypt, decryptedString)
    }

    /// Use an invalid password and check data can not be decrypted
    func test_passwordEncryption_invalidPassword() throws {
        // Create `PasswordEncryption`
        var pEncryption = try PasswordEncryption(password: password)

        // Encrypt
        let encryptedData = try pEncryption.encrypt(
            string: stringToEncrypt,
            with: password
        )

        do {
            _ = try pEncryption.decrypt(
                data: encryptedData,
                with: invalidPassword
            )
            XCTFail("Invalid password didn't throw")
            return
        } catch {
            debugPrint(error)
            guard case EncryptionError.k3NotEqual = error else {
                XCTFail("Unexpected error, expected \(EncryptionError.k3NotEqual)")
                return
            }
        }
    }

    /// Test re-encrypting changes the IV
    func test_updateIV() throws {
        // Create `PasswordEncryption`
        var pEncryption = try PasswordEncryption(password: password)
        let iv = pEncryption.keys.iv

        // Encrypt
        let encryptedData1 = try pEncryption.encrypt(
            string: stringToEncrypt,
            with: password
        )

        let iv2 = pEncryption.keys.iv
        XCTAssertNotEqual(iv, iv2)

        // Encrypt2
        let encryptedData2 = try pEncryption.encrypt(
            string: stringToEncrypt,
            with: password
        )

        let iv3 = pEncryption.keys.iv
        XCTAssertNotEqual(iv2, iv3)
        XCTAssertNotEqual(iv, iv3)
        XCTAssertNotEqual(encryptedData1, encryptedData2)
    }
}

// MARK: - PasswordEncryption + Extensions

private extension PasswordEncryption {

    /// Convert `string` to `Data` with `encoding` and encrypt using `password`
    ///
    /// - Parameters:
    ///   - string: `String`
    ///   - password: `String`
    ///   - updateIV: `Bool`
    ///   - encoding: `String.Encoding`
    ///
    /// - Returns:
    /// Encrypted `Data`
    mutating func encrypt(
        string: String,
        with password: String,
        encoding: String.Encoding = encoding
    ) throws -> Data {
        let dataToEncrypt = try string.dataOrThrow(encoding: encoding)
        return try encrypt(
            data: dataToEncrypt,
            with: password
        )
    }

    /// Decrypt`data` using `password` and convert to `String` with `encoding`
    ///
    /// - Parameters:
    ///   - data: `Data`
    ///   - password: `String`
    ///   - encoding: `String.Encoding`
    ///
    /// - Returns:
    /// Decrypted `String`
    mutating func decrypt(
        data: Data,
        with password: String,
        encoding: String.Encoding = encoding
    ) throws -> String {
        let decryptedData = try decrypt(
            data: data,
            with: password
        )
        return try decryptedData.stringOrThrow(encoding: encoding)
    }
}
