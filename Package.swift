// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "OnLaunch-iOS-Client",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "OnLaunch-iOS-Client", targets: ["OnLaunch-iOS-Client"]),
    ],
    targets: [
        .target(name: "OnLaunch-iOS-Client"),
        //dev .testTarget(name: "OnLaunch-iOS-ClientTests", dependencies: ["OnLaunch-iOS-Client"]),
    ]
)
