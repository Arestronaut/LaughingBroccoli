// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"])
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.1.0"),
        .package(path: "../Shared")
    ],
    targets: [
        .target(
            name: "Networking",
            dependencies: [
                "Factory",
                "Shared"
            ]
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"])
    ]
)
