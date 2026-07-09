// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "CollectionUI",
    platforms: [
      .iOS(.v17),
    ],
    products: [
      .library(name: "CollectionUI", targets: ["CollectionUI"]),
    ],
    targets: [
        .target(
            name: "CollectionUI",
            resources: [
              .process("Resources"),
            ],
        ),
    ],
)
