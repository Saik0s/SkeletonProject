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
    @Presents public var edit: EditFeedItemFeature.State?
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case edit(PresentationAction<EditFeedItemFeature.Action>)
    case editButtonTapped
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .edit:
        return .none

      case .editButtonTapped:
        state.edit = .init(feedItem: state.$feedItem)
        return .none
      }
    }
    .ifLet(\.$edit, action: \.edit) {
      EditFeedItemFeature()
    }
  }
}

// MARK: - FeedItemDetailsView

struct FeedItemDetailsView: View {
  @Perception.Bindable var store: StoreOf<FeedItemDetailsFeature>

  var body: some View {
    WithPerceptionTracking {
      Text(store.feedItem.content)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .navigationTitle(store.feedItem.id.uuidString)
        .toolbar {
          ToolbarItem(placement: .confirmationAction) {
            Button("Edit") {
              store.send(.editButtonTapped)
            }
          }
        }
        .sheet(item: $store.scope(state: \.edit, action: \.edit)) { store in
          EditFeedItemView(store: store)
        }
    }
  }
}
