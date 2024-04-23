//
// UserSettingsFeature.swift
//

import ComposableArchitecture
import MemberwiseInit
import SwiftUI

// MARK: - UserSettingsFeature

@Reducer
public struct UserSettingsFeature {
  @ObservableState
  public struct State: Equatable {
    @Shared(.userSettings) public var settings = UserSettings()
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
  }

  public init() {}
}

// MARK: - UserSettingsView

@MemberwiseInit(.public)
public struct UserSettingsView: View {
  @InitRaw(.public, type: StoreOf<UserSettingsFeature>)
  @Perception.Bindable var store: StoreOf<UserSettingsFeature>

  public var body: some View {
    WithPerceptionTracking {
      Form {
        Toggle("Enable Dark Mode", isOn: $store.settings.isDarkModeEnabled)
      }
    }
  }
}
