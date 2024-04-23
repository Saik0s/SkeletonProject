//
// FeedFeature.swift
//

import ComposableArchitecture
import IdentifiedCollections
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

    ///    @Shared(.feedItems) var feedItems: IdentifiedArrayOf<FeedItem> = []
    @Shared(.feedItems) var feedItems: [FeedItem] = []
  }

  public enum Action {
    case destination(PresentationAction<Destination.Action>)

    case addFeedItemButtonTapped
    case feedItemTapped(FeedItem)
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
        state.feedItems.append(FeedItem(id: .init(uuid()), content: "New feed item"))
        return .none

      case let .feedItemTapped(feedItem):
        let item = state.$feedItems.elements.first { $0.id == feedItem.id }
        guard let item else {
          state.destination = .alert(.init(
            title: .init("Feed item not found"),
            message: .init("The feed item you tapped could not be found."),
            dismissButton: .default(.init("OK"))
          ))
          return .none
        }
        state.destination = .details(FeedItemDetailsFeature.State(feedItem: item))
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
        Form {
          ForEach(store.$feedItems.elements) { $feedItem in
            WithPerceptionTracking {
              Button { store.send(.feedItemTapped(feedItem)) }
                label: { FeedItemRowView(feedItem: feedItem)
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
