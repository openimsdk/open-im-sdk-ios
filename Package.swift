// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "OpenIMSDK",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "OpenIMSDK",
            targets: ["OpenIMSDK"]
        )
    ],
    targets: [
        .target(
            name: "OpenIMSDK",
            path: "Sources/OpenIMSDK"
        ),
        .testTarget(
            name: "OpenIMSDKTests",
            dependencies: ["OpenIMSDK"],
            path: "Tests/OpenIMSDKTests"
        )
    ]
)
