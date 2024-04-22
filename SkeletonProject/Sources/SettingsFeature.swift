//
// SettingsFeature.swift
//

import ComposableArchitecture
import SwiftUI

// MARK: - SettingsFeature

@Reducer
public struct SettingsFeature {
  @ObservableState
  public struct State: Equatable {
    @Shared(.isDarkModeEnabled) public var isDarkModeEnabled = false
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
  }

  public init() {}
}

// MARK: - SettingsView

public struct SettingsView: View {
  @Perception.Bindable var store: StoreOf<SettingsFeature>

  public init(store: StoreOf<SettingsFeature>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      Form {
        Toggle("Enable Dark Mode", isOn: $store.isDarkModeEnabled)
      }
    }
  }
}

public extension PersistenceReaderKey where Self == AppStorageKey<Bool> {
  static var isDarkModeEnabled: Self {
    appStorage("isDarkModeEnabled")
  }
}
