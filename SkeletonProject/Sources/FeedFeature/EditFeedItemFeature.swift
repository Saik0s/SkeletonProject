//
// EditFeedItemFeature.swift
//

import ComposableArchitecture
import SwiftUI

// MARK: - EditFeedItemFeature

@Reducer
public struct EditFeedItemFeature {
  @ObservableState
  public struct State: Equatable {
    @Shared public var feedItem: FeedItem
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case doneButtonTapped
    case cancelButtonTapped
  }

  @Dependency(\.dismiss) public var dismiss

  public var body: some Reducer<State, Action> {
    BindingReducer()

    Reduce { _, action in
      switch action {
      case .binding:
        .none

      case .doneButtonTapped:
        .run { _ in await dismiss() }

      case .cancelButtonTapped:
        .run { _ in await dismiss() }
      }
    }
  }
}

// MARK: - EditFeedItemView

struct EditFeedItemView: View {
  @Perception.Bindable var store: StoreOf<EditFeedItemFeature>

  var body: some View {
    WithPerceptionTracking {
      NavigationStack {
        TextEditor(text: $store.feedItem.content)
          .navigationTitle("Edit FeedItem")
          .toolbar {
            ToolbarItem(placement: .confirmationAction) {
              Button("Done") {
                store.send(.doneButtonTapped)
              }
            }
          }
      }
    }
  }
}
