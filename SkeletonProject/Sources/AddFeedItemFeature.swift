//
// AddFeedItemFeature.swift
//

import ComposableArchitecture
import SwiftUI

// MARK: - AddFeedItemFeature

@Reducer
public struct AddFeedItemFeature {
  @ObservableState
  public struct State: Equatable {
    @Shared public var feedItem: FeedItem
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case saveButtonTapped
    case cancelButtonTapped
  }

  @Dependency(\.dismiss) public var dismiss

  public var body: some Reducer<State, Action> {
    BindingReducer()

    Reduce { _, action in
      switch action {
      case .binding:
        .none

      case .saveButtonTapped:
        .run { _ in
          await dismiss()
        }

      case .cancelButtonTapped:
        .run { _ in
          await dismiss()
        }
      }
    }
  }
}

// MARK: - AddFeedItemView

struct AddFeedItemView: View {
  @Perception.Bindable var store: StoreOf<AddFeedItemFeature>

  var body: some View {
    WithPerceptionTracking {
      NavigationStack {
        TextEditor(text: $store.feedItem.content)
          .navigationTitle("Edit FeedItem")
          .toolbar {
            ToolbarItem(placement: .confirmationAction) {
              Button("Done") {
                store.send(.saveButtonTapped)
              }
            }
          }
      }
    }
  }
}
