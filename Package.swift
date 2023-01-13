// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "OnLaunch-iOS-Client",
    products: [
        .library(name: "OnLaunch-iOS-Client", targets: ["OnLaunch-iOS-Client"]),
    ],
    targets: [
        .target(name: "OnLaunch-iOS-Client"),
        .testTarget(name: "OnLaunch-iOS-ClientTests", dependencies: ["OnLaunch-iOS-Client"]),
    ]
)
