// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MaGus",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
        .package(url: "https://github.com/stencilproject/Stencil.git", .upToNextMinor(from: "0.13.0")),
        .package(url: "https://github.com/kylef/PathKit", from: "0.9.0"),
        .package(url: "https://github.com/guseducampos/TOMLDecoder.git", .branch("prevent-crash")),
        .package( url: "https://github.com/Flight-School/AnyCodable", from: "0.2.3"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "3.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "MaGus",
            dependencies: ["MaGusKit"]),
        .target(
            name: "MaGusKit",
            dependencies: ["ArgumentParser", "Stencil", "PathKit", "TOMLDecoder" , "AnyCodable", "Yams"]),
        .testTarget(
            name: "MaGusKitTests",
            dependencies: ["MaGusKit"]),
    ]
)
