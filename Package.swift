// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "cool-openai-kit",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CoolOpenAIKit",
            targets: ["CoolOpenAIKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
//        .package(url: "../../ToolKit", from: "1.0.0"),
        .package(path: "ToolKit")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CoolOpenAIKit",
            dependencies: [
                .product(name: "ToolKit", package: "ToolKit")
            ]),
        .testTarget(
            name: "CoolOpenAIKitTests",
            dependencies: ["CoolOpenAIKit"]),
    ]
)
