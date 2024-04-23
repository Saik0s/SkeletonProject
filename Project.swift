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

  settings: .settings(
    base: SettingsDictionary().automaticCodeSigning(devTeam: "8A76N862C8"),
    defaultSettings: .recommended
  ),

  targets: [
    // MARK: - App

    .target(
      name: "SkeletonProject",
      // destinations: [.iPhone, .appleVision],
      destinations: .iOS,
      product: .app,
      bundleId: "me.igortarasenko.SkeletonProject.App",
      deploymentTargets: .iOS("16.0"), // .multiplatform(iOS: "16.0", visionOS: "1.0"),
      infoPlist: .extendingDefault(
        with: [
          "UILaunchStoryboardName": "LaunchScreen.storyboard",
        ]
      ),
      sources: "SkeletonProject/Sources/**",
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
        // .external(name: "Inject"),
        .external(name: "ComposableArchitecture"),
        .external(name: "MemberwiseInit"),
        .external(name: "Tagged"),

        .target(name: "Common"),
        .target(name: "NotificationServiceExtension"),
        .target(name: "WatchApp"),
        .target(name: "WidgetExtension"),
      ]
    ),
    .target(
      name: "SkeletonProjectTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "me.igortarasenko.SkeletonProject.Tests",
      infoPlist: .default,
      sources: "SkeletonProject/Tests/**",
      resources: [],
      dependencies: [
        .target(name: "SkeletonProject"),
      ]
    ),

    // MARK: - Modules

    .target(
      name: "Common",
      // destinations: [.iPhone, .appleVision, .appleWatch],
      destinations: .iOS,
      product: .staticFramework,
      productName: "Common",
      bundleId: "me.igortarasenko.SkeletonProject.Common",
      deploymentTargets: .iOS("16.0"), // .multiplatform(iOS: "16.0", watchOS: "9.0", visionOS: "1.0"),
      sources: "SkeletonModules/Common/Sources/**",
      dependencies: [
        .external(name: "ComposableArchitecture"),
        .external(name: "Tagged"),
        .external(name: "MemberwiseInit"),
      ]
    ),

    // MARK: - WatchApp

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
      resources: "WatchWidgetExtension/Resources/**"
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

    // MARK: - NotificationServiceExtension

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
      sources: "NotificationServiceExtension/**"
    ),

    // MARK: - WidgetExtension

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
      resources: "WidgetExtension/Resources/**"
    ),
  ]
)
