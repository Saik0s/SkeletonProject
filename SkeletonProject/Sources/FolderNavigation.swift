//
// FolderNavigation.swift
//

import ComposableArchitecture
import SwiftUI

// MARK: - FolderNavigation

@Reducer
struct FolderNavigation {
  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID
    var name: String = ""
    var subfolders: IdentifiedArrayOf<State> = []

    init(id: UUID? = nil, name: String = "", subfolders: IdentifiedArrayOf<Self> = []) {
      @Dependency(\.uuid) var uuid
      self.id = id ?? uuid()
      self.name = name
      self.subfolders = subfolders
    }
  }

  enum Action {
    case addSubfolderButtonTapped
    case nameTextFieldChanged(String)
    case onDelete(IndexSet)
    indirect case subfolders(IdentifiedActionOf<FolderNavigation>)
  }

  @Dependency(\.uuid) var uuid

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .addSubfolderButtonTapped:
        state.subfolders.append(State(id: uuid()))
        return .none

      case let .nameTextFieldChanged(name):
        state.name = name
        return .none

      case let .onDelete(indexSet):
        state.subfolders.remove(atOffsets: indexSet)
        return .none

      case .subfolders:
        return .none
      }
    }
    .forEach(\.subfolders, action: \.subfolders) {
      Self()
    }
  }
}

// MARK: - FolderNavigationView

struct FolderNavigationView: View {
  @Perception.Bindable var store: StoreOf<FolderNavigation>

  var body: some View {
    WithPerceptionTracking {
      Form {
        ForEach(store.scope(state: \.subfolders, action: \.subfolders)) { subfolderStore in
          @Perception.Bindable var subfolderStore = subfolderStore
          NavigationLink {
            Self(store: subfolderStore)
          } label: {
            HStack {
              TextField("Untitled", text: $subfolderStore.name.sending(\.nameTextFieldChanged))
              Image(systemName: "folder")
                .font(.callout)
                .foregroundStyle(.secondary)
            }
          }
        }
        .onDelete { store.send(.onDelete($0)) }
      }
      .navigationTitle(store.name.isEmpty ? "Untitled" : store.name)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Add Subfolder") { store.send(.addSubfolderButtonTapped) }
        }
      }
    }
  }
}
