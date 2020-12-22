// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Dotenv",
    products: [
        .library(
            name: "Dotenv",
            targets: ["Dotenv"]),
    ],
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
