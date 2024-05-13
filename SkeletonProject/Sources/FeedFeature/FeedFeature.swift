//
// FeedFeature.swift
//

import ComposableArchitecture
import IdentifiedCollections
import SwiftUI
import Tagged

// MARK: - FeedFeature

@Reducer
public struct FeedFeature {
  @Reducer(state: .equatable)
  public enum Path {
    case details(FeedItemDetailsFeature)
  }

  @Reducer(state: .equatable)
  public enum Destination {
    case alert(AlertState<Alert>)
    case add(AddFeedItemFeature)

    @CasePathable
    public enum Alert {
      case confirmDeletion
    }
  }

  @Reducer
  public struct Row {
    @ObservableState
    public struct State: Equatable, Identifiable {
      public var id: FeedItem.ID { item.id }
      @Shared var item: FeedItem
      var isProcessing = false
    }

    public enum Action: BindableAction {
      case binding(BindingAction<State>)
      case processButtonTapped
      case didFinishProcessing(TaskResult<Void>)
    }

    @Dependency(\.continuousClock) var clock
    private enum CancelID { case load }

    public var body: some Reducer<State, Action> {
      BindingReducer()

      Reduce { state, action in
        switch action {
        case .binding:
          return .none

        case .processButtonTapped:
          state.isProcessing = true
          return .run { send in
            try await clock.sleep(for: .seconds(5))
            await send(.didFinishProcessing(.success(())))
          }
          .cancellable(id: CancelID.load, cancelInFlight: true)

        case .didFinishProcessing(.success):
          state.isProcessing = false
          return .none

        case .didFinishProcessing(.failure):
          state.isProcessing = false
          return .none
        }
      }
    }
  }

  @ObservableState
  public struct State: Equatable {
    var path = StackState<Path.State>()
    @Presents var destination: Destination.State?
    @Shared(.feedItems) var feedItems: [FeedItem] = []
    var rows: IdentifiedArrayOf<Row.State> = []
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case onTask
    case path(StackActionOf<Path>)
    case destination(PresentationAction<Destination.Action>)
    case row(IdentifiedActionOf<Row>)
    case feedItemsAmountChanged
    case addFeedItemButtonTapped
    case onDelete(IndexSet)
    case rowTapped(Shared<FeedItem>)
  }

  @Dependency(\.uuid) public var uuid

  public var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .onTask:
        updateRows(&state)
        // In this case state.$feedItems.elements has old values when processing the action
        // return .publisher {
        //   state.$feedItems.publisher.map({ $0.map(\.id) }).removeDuplicates().map { _ in Action.feedItemsAmountChanged }
        // }
        return .run { [feedItems = state.$feedItems] send in
          for await _ in feedItems.publisher.map({ $0.map(\.id) }).removeDuplicates().values {
            await send(.feedItemsAmountChanged)
          }
        }

      case .path:
        return .none

      case .destination(.presented(.add(.delegate(.saveButtonTapped)))):
        if let item = state.destination?.add {
          state.feedItems.append(item.feedItem)
          state.destination = nil
        }
        return .none

      case .destination:
        return .none

      case .row:
        return .none

      case .feedItemsAmountChanged:
        updateRows(&state)
        return .none

      case .addFeedItemButtonTapped:
        state.destination = .add(AddFeedItemFeature.State(
          feedItem: FeedItem(id: .init(uuid()), content: "New feed item")
        ))
        return .none

      case let .onDelete(indexSet):
        state.feedItems.remove(atOffsets: indexSet)
        return .none

      case let .rowTapped(item):
        state.path.append(.details(FeedItemDetailsFeature.State(feedItem: item)))
        return .none
      }
    }
    .forEach(\.path, action: \.path)
    .ifLet(\.$destination, action: \.destination)
    .forEach(\.rows, action: \.row) {
      Row()
    }
  }

  func updateRows(_ state: inout State) {
    state.rows = .init(uncheckedUniqueElements: state.$feedItems.elements.map { $feedItem in
      state.rows[id: feedItem.id] ?? .init(item: $feedItem)
    })
  }
}

// MARK: - FeedView

public struct FeedView: View {
  @Perception.Bindable public var store: StoreOf<FeedFeature>

  public var body: some View {
    WithPerceptionTracking {
      NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
        List {
          ForEach(store.scope(state: \.rows, action: \.row)) { rowStore in
            WithPerceptionTracking {
              Button { store.send(.rowTapped(rowStore.$item)) } label: {
                FeedItemRowView(store: rowStore)
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
        .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
        .sheet(
          item: $store.scope(state: \.destination?.add, action: \.destination.add)
        ) { store in
          AddFeedItemView(store: store)
        }
        .navigationTitle("Feed")
      } destination: { store in
        switch store.case {
        case .details(let store):
          FeedItemDetailsView(store: store)
        }
      }
      .task { await store.send(.onTask).finish() }
    }
  }
}

// MARK: - FeedItemRowView

private struct FeedItemRowView: View {
  @Perception.Bindable var store: StoreOf<FeedFeature.Row>

  var body: some View {
    WithPerceptionTracking {
      VStack(alignment: .leading) {
        Text(store.item.id.uuidString)
          .font(.footnote)
          .foregroundStyle(Color(.systemGray))

        Text(store.item.content)
          .font(.body)
          .foregroundStyle(Color(.label))
          .lineLimit(1)

        Button { store.send(.processButtonTapped) }
          label: {
            if store.isProcessing {
              ProgressView()
            } else {
              Text("Process")
            }
          }
          .buttonStyle(.bordered)
      }
      .animation(.interpolatingSpring(stiffness: 100, damping: 10), value: store.isProcessing)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}
