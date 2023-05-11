// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedUI",
    products: [
        .library(
            name: "SharedUI",
            targets: ["SharedUI"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SharedUI",
            dependencies: []
        ),
        .testTarget(
            name: "SharedUITests",
            dependencies: ["SharedUI"]
        )
    ]
)
