// swift-tools-version: 5.10
import PackageDescription

#if TUIST
  import ProjectDescription

  let packageSettings = PackageSettings(
    // Customize the product types for specific package product
    // Default is .staticFramework
    // productTypes: ["Alamofire": .framework,]
    productTypes: [:]
  )
#endif

let package = Package(
  name: "SkeletonProject",
  dependencies: [
    .package(url: "https://github.com/krzysztofzablocki/Inject.git", branch: "main"),

    .package(url: "https://github.com/gohanlon/swift-memberwise-init-macro", from: "0.4.0"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.10.2"),
    .package(url: "https://github.com/pointfreeco/swift-tagged.git", from: "0.10.0"),
  ]
)
