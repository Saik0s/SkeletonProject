//
// FeedFeature.swift
//

import ComposableArchitecture
import SwiftUI

// MARK: - FeedFeature

@Reducer
public struct FeedFeature {
  @Reducer(state: .equatable)
  public enum Destination {
    case alert(AlertState<Alert>)
    case add(AddFeedItemFeature)
    case details(FeedItemDetailsFeature)

    @CasePathable
    public enum Alert {
      case confirmDeletion
    }
  }

  @ObservableState
  public struct State: Equatable {
    @Presents var destination: Destination.State?

    @Shared(.memNotes) public var feedItems: IdentifiedArrayOf<FeedItem> = []
  }

  public enum Action {
    case destination(PresentationAction<Destination.Action>)

    case addFeedItemButtonTapped
    case onDelete(IndexSet)
  }

  @Dependency(\.uuid) public var uuid

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .destination(.presented(.add(.saveButtonTapped))):
//        if let feedItem = state.editFeedItem?.feedItem {
//          state.feedItems.append(feedItem)
//        }
        return .none

      case .destination:
        return .none

      case .addFeedItemButtonTapped:
        return .none

      case let .onDelete(indexSet):
        state.feedItems.remove(atOffsets: indexSet)
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
}

// MARK: - FeedView

public struct FeedView: View {
  @Perception.Bindable public var store: StoreOf<FeedFeature>

  public var body: some View {
    WithPerceptionTracking {
      NavigationStack {
        List {
          ForEach(store.$feedItems.elements) { $feedItem in
            WithPerceptionTracking {
              NavigationLink(state: FeedFeature.Destination.State.details(FeedItemDetailsFeature.State(feedItem: $feedItem))) {
                FeedItemRowView(feedItem: feedItem)
              }
            }
          }
          .onDelete { indexSet in
            store.send(.onDelete(indexSet))
          }
        }
        .toolbar {
          Button {
            store.send(.addFeedItemButtonTapped)
          } label: {
            Image(systemName: "plus")
          }
        }
        .navigationDestination(
          item: $store.scope(state: \.destination?.details, action: \.destination.details)
        ) { store in
          FeedItemDetailsView(store: store)
        }
        .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
        .navigationTitle("Feed")
      }
    }
  }
}

// MARK: - FeedItemRowView

private struct FeedItemRowView: View {
  let feedItem: FeedItem

  var body: some View {
    VStack(alignment: .leading) {
      Text(feedItem.id.uuidString)
        .font(.caption)
      Spacer()
      Text(feedItem.content)
        .font(.caption)
        .lineLimit(1)
    }
    .padding()
  }
}
