//
// FeedItemDetailsFeature.swift
//

import ComposableArchitecture
import SwiftUI

// MARK: - FeedItemDetailsFeature

@Reducer
public struct FeedItemDetailsFeature {
  @ObservableState
  public struct State: Equatable {
    @Shared public var feedItem: FeedItem
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()

    Reduce { _, action in
      switch action {
      case .binding:
        .none
      }
    }
  }
}

// MARK: - FeedItemDetailsView

struct FeedItemDetailsView: View {
  @Perception.Bindable var store: StoreOf<FeedItemDetailsFeature>

  var body: some View {
    WithPerceptionTracking {
      NavigationStack {
        Text(store.feedItem.content)
          .navigationTitle(store.feedItem.id.uuidString)
      }
    }
  }
}
