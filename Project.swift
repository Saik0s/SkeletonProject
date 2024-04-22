//
// Project.swift
//

import ProjectDescription

let project = Project(
  name: "SkeletonProject",
  options: .options(
    textSettings: .textSettings(
      indentWidth: 2,
      tabWidth: 2
    )
  ),
  targets: [
    .target(
      name: "SkeletonProject",
      destinations: .iOS,
      product: .app,
      bundleId: "me.igortarasenko.SkeletonProject",
      infoPlist: .extendingDefault(
        with: [
          "UILaunchStoryboardName": "LaunchScreen.storyboard",
        ]
      ),
      sources: ["SkeletonProject/Sources/**"],
      resources: ["SkeletonProject/Resources/**"],
      dependencies: [
        .external(name: "ComposableArchitecture"),
        .external(name: "Inject"),
      ]
    ),
    .target(
      name: "SkeletonProjectTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "me.igortarasenko.SkeletonProjectTests",
      infoPlist: .default,
      sources: ["SkeletonProject/Tests/**"],
      resources: [],
      dependencies: [.target(name: "SkeletonProject")]
    ),
  ]
)
