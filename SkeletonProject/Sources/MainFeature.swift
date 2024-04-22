//
// MainFeature.swift
//

import ComposableArchitecture
import SwiftUI

// MARK: - MainFeature

@Reducer
public struct MainFeature {
  @ObservableState
  public struct State: Equatable {
    public var count = 0
  }

  public enum Action {
    case increment
  }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .increment:
        state.count += 1
        return .none
      }
    }
  }
}

// MARK: - MainView

public struct MainView: View {
  @Bindable public var store: StoreOf<MainFeature>

  public var body: some View {
    VStack {
      Text("Count: \(store.count)")
      Button("Increment") {
        store.send(.increment)
      }
    }
  }
}
