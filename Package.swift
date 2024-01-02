// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SSPhotoKit",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SSPhotoKitEngine",
            targets: ["SSPhotoKitEngine"]),
        .library(
            name: "SSPhotoKitUI",
            targets: ["SSPhotoKitUI"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SSPhotoKitEngine",
            dependencies: [],
            swiftSettings: [.define("SPM")]),
        .target(
            name: "SSPhotoKitUI",
            dependencies: ["SSPhotoKitEngine"],
            swiftSettings: [.define("SPM")]),
        .testTarget(
            name: "SSPhotoKitTests",
            dependencies: ["SSPhotoKitEngine", "SSPhotoKitUI"]),
    ]
)
