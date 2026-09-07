// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "OpenIMSDK",
    platforms: [
        .iOS(.v13)
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
            dependencies: [
                .target(name: "OpenIMCore", condition: .when(platforms: [.iOS]))
            ],
            path: "Sources/OpenIMSDK",
            linkerSettings: [
                .linkedLibrary("resolv")
            ]
        ),
        .binaryTarget(
            name: "OpenIMCore",
            path: "Example/Pods/OpenIMSDKCore/Framework/OpenIMCore.xcframework"
        ),
        .testTarget(
            name: "OpenIMSDKTests",
            dependencies: ["OpenIMSDK"],
            path: "Tests/OpenIMSDKTests"
        )
    ]
)
