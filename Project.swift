//
// Project.swift
//

import Foundation
import ProjectDescription

let projectBaseSettings: SettingsDictionary = [
  "_APP_VERSION": "0.0.1",
  "_APP_BUILD_VERSION": "1",
]

let isRevealSupported = FileManager.default.fileExists(atPath: "SkeletonProject/Support/RevealServer.xcframework")
print("RevealServer.xcframework is \(isRevealSupported ? "supported" : "not supported")")

let project = Project(
  name: "SkeletonProject",

  options: .options(
    textSettings: .textSettings(
      indentWidth: 2,
      tabWidth: 2
    )
  ),

  settings: .settings(
    base: projectBaseSettings.automaticCodeSigning(devTeam: "8A76N862C8"),
    debug: [
      "OTHER_SWIFT_FLAGS": "-D DEBUG $(inherited) -Xfrontend -warn-long-function-bodies=500 -Xfrontend -warn-long-expression-type-checking=500 -Xfrontend -debug-time-function-bodies -Xfrontend -enable-actor-data-race-checks",
      "OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable -Xlinker -undefined -Xlinker dynamic_lookup",
    ]
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
          "UIUserInterfaceStyle": "Dark",
          "UIViewControllerBasedStatusBarAppearance": true,
          "UIStatusBarStyle": "UIStatusBarStyleLightContent",
          "ITSAppUsesNonExemptEncryption": false,
          "CFBundleShortVersionString": "$(_APP_VERSION)",
          "CFBundleVersion": "$(_APP_BUILD_VERSION)",
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
      scripts: isRevealSupported
        ? [
          .post(
            script: """
            export REVEAL_SERVER_FILENAME="RevealServer.xcframework"
            export REVEAL_SERVER_PATH="${SRCROOT}/SkeletonProject/Support/${REVEAL_SERVER_FILENAME}"
            [ -d "${REVEAL_SERVER_PATH}" ] && "${REVEAL_SERVER_PATH}/Scripts/integrate_revealserver.sh" \
            || echo "Reveal Server not loaded into ${TARGET_NAME}: ${REVEAL_SERVER_FILENAME} could not be found."
            """,
            name: "Reveal Server",
            basedOnDependencyAnalysis: false
          ),
        ]
        : [],
      dependencies: [
        .external(name: "Inject"),

        .external(name: "ComposableArchitecture"),
        .external(name: "MemberwiseInit"),
        .external(name: "Tagged"),

        .target(name: "Common"),
        .target(name: "NotificationServiceExtension"),
        .target(name: "WatchApp"),
        .target(name: "WidgetExtension"),
      ]
        // Check if RevealServer framework exists at this path and only then include it in this array of dependencies
        + (isRevealSupported
          ? [.xcframework(path: "SkeletonProject/Support/RevealServer.xcframework", status: .optional)]
          : [])
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
        "CFBundleShortVersionString": "$(_APP_VERSION)",
        "CFBundleVersion": "$(_APP_BUILD_VERSION)",
        "NSExtension": [
          "NSExtensionPointIdentifier": "com.apple.widgetkit-extension",
        ],
      ]),
      sources: "WidgetExtension/Sources/**",
      resources: "WidgetExtension/Resources/**"
    ),
  ]
)
