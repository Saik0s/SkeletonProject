//
// MainFeature.swift
//

import ComposableArchitecture
import SwiftUI

// MARK: - MainFeature

@Reducer
public struct MainFeature {
  public enum Tab { case counter, settings }

  @ObservableState
  public struct State: Equatable {
    var currentTab = Tab.counter
    var counter = CounterFeature.State()
    var settings = SettingsFeature.State()
  }

  public enum Action {
    case counter(CounterFeature.Action)
    case settings(SettingsFeature.Action)
    case selectTab(Tab)
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.counter, action: \.counter) {
      CounterFeature()
    }

    Scope(state: \.settings, action: \.settings) {
      SettingsFeature()
    }

    Reduce { state, action in
      switch action {
      case .counter, .settings:
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
        CounterView(
          store: store.scope(state: \.counter, action: \.counter)
        )
        .tag(MainFeature.Tab.counter)
        .tabItem { Text("Counter") }

        SettingsView(
          store: store.scope(state: \.settings, action: \.settings)
        )
        .tag(MainFeature.Tab.settings)
        .tabItem { Text("Settings") }
      }
    }
  }
}
