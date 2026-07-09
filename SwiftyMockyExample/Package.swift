// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let name = "SwiftyMockyExample"
let package = Package(
    name: name,
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: name,
            targets: [name]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/MakeAWishFoundation/SwiftyMocky",
            branch: "master" // Version should match Mintfile
        )
    ],
    targets: [
        .target(
            name: name,
            path: "Sources"
        ),
        .testTarget(
            name: "\(name)Tests",
            dependencies: [
                .byName(name: name),
                "SwiftyMocky"
            ],
            path: "Tests"
        )
    ]
)
