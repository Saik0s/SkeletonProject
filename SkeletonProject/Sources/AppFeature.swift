//
// AppFeature.swift
//

import ComposableArchitecture
import SwiftUI

// MARK: - AppFeature

@Reducer(state: .equatable)
public enum AppFeature {
  case splash(SplashFeature)
  case main(MainFeature)

  public static var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .splash(.delegate(.done)):
        state = .main(MainFeature.State())
        return .none

      case .splash:
        return .none

      case .main:
        return .none
      }
    }
    .ifCaseLet(\.splash, action: \.splash) {
      SplashFeature()
    }
    .ifCaseLet(\.main, action: \.main) {
      MainFeature()
    }
  }
}

// MARK: - AppView

public struct AppView: View {
  let store: StoreOf<AppFeature>

  public init(store: StoreOf<AppFeature>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      switch store.case {
      case let .splash(store):
        SplashView(store: store)

      case let .main(store):
        NavigationStack {
          MainView(store: store)
        }
      }
    }
  }
}
