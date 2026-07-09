// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "FlowLayout",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "FlowLayout",
            targets: ["FlowLayout"]
        )
    ],
    targets: [
        .target(
            name: "FlowLayout",
            path: "Sources"
        ),
        .testTarget(
            name: "FlowLayoutTests",
            dependencies: ["FlowLayout"],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [.v5],
)
