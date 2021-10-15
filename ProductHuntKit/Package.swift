// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "ProductHuntKit",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(
      name: "ProductHuntKit",
      targets: ["ProductHuntKit"])
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "ProductHuntKit",
      dependencies: []),
    .testTarget(
      name: "ProductHuntKitTests",
      dependencies: ["ProductHuntKit"])
  ]
)
