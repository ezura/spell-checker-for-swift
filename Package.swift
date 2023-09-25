// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "typokana",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "typokana", targets: ["typokana"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", .exact("508.0.0")),
        .package(
            url:"https://github.com/rokasambrazevicius2/SwiftSyntaxExtensions.git",
            .branchItem("updateVersion")
        ),
        .package(url: "https://github.com/SDGGiesbrecht/swift-package-manager.git", .exact("0.50700.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "typokana",
            dependencies: [
                "SwiftSyntax",
                "SwiftSyntaxParser",
                "SwiftSyntaxExtensions",
                "SwiftPM"
            ]),
        .testTarget(
            name: "typokanaTests",
            dependencies: ["typokana"]),
    ]
)
