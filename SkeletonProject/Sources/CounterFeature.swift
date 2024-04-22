//
// CounterFeature.swift
//

import ComposableArchitecture
import SwiftUI

// MARK: - CounterFeature

@Reducer
public struct CounterFeature {
  @ObservableState
  public struct State: Equatable {
    @Shared(.isDarkModeEnabled) public var isDarkModeEnabled = false
    public var count = 0
  }

  public enum Action {
    case increment
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .increment:
        state.count += 1
        return .none
      }
    }
  }
}

// MARK: - CounterView

public struct CounterView: View {
  @Perception.Bindable public var store: StoreOf<CounterFeature>

  public var body: some View {
    WithPerceptionTracking {
      VStack {
        Text("Count: \(store.count)")
        Button("Increment") {
          store.send(.increment)
        }
      }
      .preferredColorScheme(store.isDarkModeEnabled ? .dark : .light)
    }
  }
}
