//
// SplashFeature.swift
//

import ComposableArchitecture
import SwiftUI

// MARK: - SplashFeature

@Reducer
public struct SplashFeature {
  @ObservableState
  public struct State: Equatable {
    public var timer = 3
  }

  public enum Action {
    case onTask
    case timerTick

    case delegate(Delegate)

    public enum Delegate {
      case done
    }
  }

  @Dependency(\.continuousClock) var clock

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onTask:
        return .run { send in
          await startTimer(send: send)
        }

      case .timerTick:
        guard state.timer > 0 else {
          return .send(.delegate(.done))
        }
        state.timer -= 1

        return .none

      case .delegate:
        return .none
      }
    }
  }

  private func startTimer(send: Send<Action>) async {
    for await _ in clock.timer(interval: .seconds(1)) {
      await send(.timerTick)
    }
  }
}

// MARK: - SplashView

public struct SplashView: View {
  @Bindable public var store: StoreOf<SplashFeature>

  public var body: some View {
    VStack {
      Text("\(store.timer)")
        .font(.system(size: 100))
    }
    .task {
      await store.send(.onTask).finish()
    }
  }
}
