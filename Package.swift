// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to
// build this package.

import PackageDescription

let package = Package(
  name: "Alexis",
  products: [
    // Products define the executables and libraries a package produces, making
    // them visible to
    // other packages.
    .library(
      name: "Alexis",
      targets: ["Alexis"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/thebarndog/swift-dotenv.git", from: "2.0.0")
  ],
  targets: [
    .target(
      name: "Alexis"
    ),
    .testTarget(
      name: "AlexisTests",
      dependencies: [
        "Alexis",
        .product(name: "SwiftDotenv", package: "swift-dotenv"),
      ]
    ),
  ]
)
