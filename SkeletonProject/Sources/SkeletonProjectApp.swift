//
// SkeletonProjectApp.swift
//

import ComposableArchitecture
import SwiftUI

@main
struct SkeletonProjectApp: App {
  @MainActor static let store = Store(initialState: AppFeature.State.splash(.init())) {
    AppFeature.body._printChanges()
  }

  var body: some Scene {
    WindowGroup {
      if _XCTIsTesting {
        // NB: Don't run application in tests to avoid interference between the app and the test.
        EmptyView()
      } else {
        WithPerceptionTracking {
          AppView(store: Self.store)
        }
      }
    }
  }
}
