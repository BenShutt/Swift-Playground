//
//  Data+Signing.swift
//  PasswordEncryption
//
//  Created by Ben Shutt on 24/04/2021.
//

import Foundation

// NOT USED

extension Data {

    /// Define `data = self`.
    ///
    /// Create a cryptographic signature on a block of `data` by first creating a hash of the `data`
    /// and then encrypting this digest with the `privateKey`.
    /// A recipient uses your public key to decrypt the signature, while independently re-creating the
    /// hash of the original `data`.
    /// If the decrypted hash and the computed one match, the recipient can be sure the data is
    /// from the owner of the `privateKey` that corresponds to the public key.
    ///
    /// - Parameters:
    ///   - privateKey: `SecKey`
    ///   - algorithm: `SecKeyAlgorithm`
    ///
    /// - Throws: `Error` if `algorithm` is not supporting or the signing fails
    /// - Returns: `Data` signature
    func sign(
        with privateKey: SecKey,
        algorithm: SecKeyAlgorithm = .rsaSignatureMessagePKCS1v15SHA512
    ) throws -> Data {
        // This function might return false, for example, if the key’s
        // kSecAttrCanSign attribute is set to false. This situation might
        // happen if you used a public key instead of a private one
        // (despite the variable name).
        // Similarly, if you attempt to use an RSA key with one of the
        // ECDSA algorithms, the check fails.
        guard SecKeyIsAlgorithmSupported(privateKey, .sign, algorithm) else {
            throw EncryptionError.unsupportedAlgorithm(algorithm)
        }

        // Conduct the verification
        var error: Unmanaged<CFError>!
        guard let signature = SecKeyCreateSignature(
            privateKey,
            algorithm,
            self as CFData,
            &error
        ) as Data? else {
            throw error.takeRetainedValue() as Error
        }

        return signature
    }
}
