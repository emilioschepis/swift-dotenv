// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Dotenv",
    dependencies: [],
    targets: [
        .target(
            name: "Dotenv",
            dependencies: []),
        .testTarget(
            name: "DotenvTests",
            dependencies: ["Dotenv"]),
    ]
)
