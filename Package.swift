// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to
// build this package.

import PackageDescription

let package = Package(
  name: "NotionKit",
  products: [
    .library(
      name: "NotionKit",
      targets: ["NotionKit"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/thebarndog/swift-dotenv.git", from: "2.1.0")
  ],
  targets: [
    .target(
      name: "NotionKit"
    ),
    .testTarget(
      name: "NotionKitTests",
      dependencies: [
        "NotionKit",
        .product(name: "SwiftDotenv", package: "swift-dotenv"),
      ]
    ),
  ]
)
