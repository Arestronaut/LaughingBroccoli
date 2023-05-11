// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Repository",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Repository",
            targets: ["Repository"]),
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.1.0"),
        .package(path: "../Networking"),
        .package(path: "../Domain"),
        .package(path: "../Shared")
    ],
    targets: [
        .target(
            name: "Repository",
            dependencies: [
                "Factory",
                "Networking",
                "Domain",
                "Shared"
            ]),
        .testTarget(
            name: "RepositoryTests",
            dependencies: ["Repository"]),
    ]
)
