// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PasswordEncryption",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        .package(
            url: "https://github.com/krzyzanowskim/CryptoSwift.git",
            .upToNextMajor(from: "1.8.2")
        )
    ],
    targets: [
        .target(
            name: "PasswordEncryption",
            dependencies: ["CryptoSwift"],
            path: "Sources"
        ),
        .testTarget(
            name: "PasswordEncryptionTests",
            dependencies: ["PasswordEncryption"],
            path: "Tests"
        )
    ]
)
