// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SkeletonModules",
  defaultLocalization: "en",
  platforms: [.iOS(.v16), .macOS(.v13)],
  products: [
    .library(name: "Common", targets: ["Common"]),
    .library(name: "SharedModels", targets: ["SharedModels"]),
    .library(name: "FeedFeature", targets: ["FeedFeature"]),
  ],
  dependencies: [
    .package(url: "https://github.com/krzysztofzablocki/Inject.git", branch: "main"),

    .package(url: "https://github.com/gohanlon/swift-memberwise-init-macro", from: "0.4.0"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.10.4"),
    .package(url: "https://github.com/pointfreeco/swift-tagged.git", from: "0.10.0"),
  ],
  targets: [
    .target(
      name: "Common",
      dependencies: [
        .product(name: "Inject", package: "Inject"),
        .product(name: "MemberwiseInit", package: "swift-memberwise-init-macro"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "Tagged", package: "swift-tagged"),
      ]
    ),
    .target(
      name: "SharedModels",
      dependencies: [
        .target(name: "Common"),
      ]
    ),
    .target(
      name: "FeedFeature",
      dependencies: [
        .target(name: "Common"),
        .target(name: "SharedModels"),
      ]
    ),
    .testTarget(name: "FeedFeatureTests", dependencies: ["FeedFeature"]),
  ]
)
