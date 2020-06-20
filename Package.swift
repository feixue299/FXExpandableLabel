// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FXExpandableLabel",
    platforms: [
        .iOS(.v9)
    ],
    products: [
    .library(name: "FXExpandableLabel", targets: ["FXExpandableLabel"])
    ],
    targets: [
        .target(
            name: "FXExpandableLabel",
            path: "Sources",
            publicHeadersPath: "."),
    ]
)
