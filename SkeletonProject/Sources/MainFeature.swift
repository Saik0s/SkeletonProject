//
// MainFeature.swift
//

import ComposableArchitecture
import SwiftUI

// MARK: - MainFeature

@Reducer
public struct MainFeature {
  public enum Tab { case feed, settings }

  @ObservableState
  public struct State: Equatable {
    var currentTab = Tab.feed
    var feed = FeedFeature.State()
    var settings = UserSettingsFeature.State()
  }

  public enum Action {
    case feed(FeedFeature.Action)
    case settings(UserSettingsFeature.Action)
    case selectTab(Tab)
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.feed, action: \.feed) {
      FeedFeature()
    }

    Scope(state: \.settings, action: \.settings) {
      UserSettingsFeature()
    }

    Reduce { state, action in
      switch action {
      case .feed, .settings:
        return .none

      case let .selectTab(tab):
        state.currentTab = tab
        return .none
      }
    }
  }
}

// MARK: - MainView

public struct MainView: View {
  @Perception.Bindable public var store: StoreOf<MainFeature>

  public var body: some View {
    WithPerceptionTracking {
      TabView(selection: $store.currentTab.sending(\.selectTab)) {
        FeedView(store: store.scope(state: \.feed, action: \.feed))
          .tag(MainFeature.Tab.feed)
          .tabItem {
            Label("Feed", systemImage: "list.bullet")
          }

        UserSettingsView(store: store.scope(state: \.settings, action: \.settings))
          .tag(MainFeature.Tab.settings)
          .tabItem {
            Label("Settings", systemImage: "gear")
          }
      }
      .preferredColorScheme(store.settings.settings.isDarkModeEnabled ? .dark : .light)
    }
  }
}
