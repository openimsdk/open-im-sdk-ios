// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "OpenIMSDK",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "OpenIMSDK", targets: ["OpenIMSDK"])
    ],
    dependencies: [
        .package(url: "https://github.com/bc1pjerry/open-im-sdk-ios.git", from: "1.0.1"),
        .package(url: "https://github.com/CoderMJLee/MJExtension.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "OpenIMSDK",
            dependencies: [
                "OpenIMSDK",
                "MJExtension"
            ],
            path: "Sources",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("OpenIMSDK")
            ]
        )
    ],
    cxxLanguageStandard: .cxx14
)
