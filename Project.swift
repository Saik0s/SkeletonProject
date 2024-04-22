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
  // settings: .settings(base: [
  //   "OTHER_LDFLAGS": [
  //     "$(inherited)",
  //     "-ObjC",
  //   ],
  //   "BITCODE_ENABLED": "NO",
  // ]),
  targets: [
    .target(
      name: "SkeletonProject",
      destinations: [.iPhone, .appleVision],
      product: .app,
      bundleId: "me.igortarasenko.SkeletonProject.App",
      deploymentTargets: .multiplatform(iOS: "16.0", visionOS: "1.0"),
      infoPlist: .extendingDefault(
        with: [
          "UILaunchStoryboardName": "LaunchScreen.storyboard",
        ]
      ),
      sources: ["SkeletonProject/Sources/**"],
      resources: .resources(
        ["SkeletonProject/Resources/**"],
        privacyManifest: .privacyManifest(
          tracking: false,
          trackingDomains: [],
          collectedDataTypes: [
            [
              "NSPrivacyCollectedDataType": "NSPrivacyCollectedDataTypeName",
              "NSPrivacyCollectedDataTypeLinked": false,
              "NSPrivacyCollectedDataTypeTracking": false,
              "NSPrivacyCollectedDataTypePurposes": [
                "NSPrivacyCollectedDataTypePurposeAppFunctionality",
              ],
            ],
          ],
          accessedApiTypes: [
            [
              "NSPrivacyAccessedAPIType": "NSPrivacyAccessedAPICategoryUserDefaults",
              "NSPrivacyAccessedAPITypeReasons": [
                "CA92.1",
              ],
            ],
          ]
        )
      ),
      dependencies: [
        .external(name: "ComposableArchitecture"),
        .external(name: "Inject"),
        .target(name: "Common"),
        .target(name: "NotificationServiceExtension"),
        .target(name: "WidgetExtension"),
        .target(name: "WatchApp"),
      ]
    ),
    .target(
      name: "SkeletonProjectTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "me.igortarasenko.SkeletonProject.Tests",
      infoPlist: .default,
      sources: ["SkeletonProject/Tests/**"],
      resources: [],
      dependencies: [.target(name: "SkeletonProject")]
    ),
    .target(
      name: "WatchApp",
      destinations: [.appleWatch],
      product: .app,
      bundleId: "me.igortarasenko.SkeletonProject.App.watchkitapp",
      infoPlist: nil,
      sources: "WatchApp/Sources/**",
      resources: "WatchApp/Resources/**",
      dependencies: [
        .target(name: "WatchWidgetExtension"),
      ],
      settings: .settings(
        base: [
          "GENERATE_INFOPLIST_FILE": true,
          "CURRENT_PROJECT_VERSION": "1",
          "MARKETING_VERSION": "1.0",
          "INFOPLIST_KEY_UISupportedInterfaceOrientations": [
            "UIInterfaceOrientationPortrait",
            "UIInterfaceOrientationPortraitUpsideDown",
          ],
          "INFOPLIST_KEY_WKCompanionAppBundleIdentifier": "me.igortarasenko.SkeletonProject.App",
          "INFOPLIST_KEY_WKRunsIndependentlyOfCompanionApp": false,
        ]
      )
    ),
    .target(
      name: "WatchWidgetExtension",
      destinations: [.appleWatch],
      product: .appExtension,
      bundleId: "me.igortarasenko.SkeletonProject.App.watchkitapp.widgetExtension",
      infoPlist: .extendingDefault(with: [
        "CFBundleDisplayName": "$(PRODUCT_NAME)",
        "NSExtension": [
          "NSExtensionPointIdentifier": "com.apple.widgetkit-extension",
        ],
      ]),
      sources: "WatchWidgetExtension/Sources/**",
      resources: "WatchWidgetExtension/Resources/**",
      dependencies: [
      ]
    ),
    .target(
      name: "WatchAppTests",
      destinations: [.appleWatch],
      product: .unitTests,
      bundleId: "me.igortarasenko.SkeletonProject.App.watchkitapptests",
      infoPlist: .default,
      sources: "WatchApp/Tests/**",
      dependencies: [
        .target(name: "WatchApp"),
      ]
    ),
    .target(
      name: "Common",
      destinations: [.iPhone, .appleVision, .appleWatch],
      product: .staticFramework,
      productName: "Common",
      bundleId: "me.igortarasenko.SkeletonProject.Common",
      deploymentTargets: .multiplatform(iOS: "16.0", watchOS: "9.0", visionOS: "1.0"),
      sources: [
        "SkeletonModules/Common/Sources/**",
      ],
      dependencies: [
        .external(name: "ComposableArchitecture"),
      ]
    ),
    .target(
      name: "NotificationServiceExtension",
      destinations: .iOS,
      product: .appExtension,
      bundleId: "me.igortarasenko.SkeletonProject.App.NotificationServiceExtension",
      infoPlist: .extendingDefault(with: [
        "CFBundleDisplayName": "$(PRODUCT_NAME)",
        "NSExtension": [
          "NSExtensionPointIdentifier": "com.apple.usernotifications.service",
          "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).NotificationService",
        ],
      ]),
      sources: "NotificationServiceExtension/**",
      dependencies: [
      ]
    ),
    .target(
      name: "WidgetExtension",
      destinations: .iOS,
      product: .appExtension,
      bundleId: "me.igortarasenko.SkeletonProject.App.WidgetExtension",
      infoPlist: .extendingDefault(with: [
        "CFBundleDisplayName": "$(PRODUCT_NAME)",
        "NSExtension": [
          "NSExtensionPointIdentifier": "com.apple.widgetkit-extension",
        ],
      ]),
      sources: "WidgetExtension/Sources/**",
      resources: "WidgetExtension/Resources/**",
      dependencies: [
      ]
    ),
  ]
)
