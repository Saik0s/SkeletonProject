//
// FeedFeature.swift
//

import ComposableArchitecture
import SwiftUI

// MARK: - Note

public struct Note: Identifiable, Equatable, Codable {
  public var id: UUID
  public var content: String
}

// MARK: - FeedFeature

@Reducer
public struct FeedFeature {
  @ObservableState
  public struct State: Equatable {
    @Shared(.memNotes) public var notes: IdentifiedArrayOf<Note> = []
    @Presents var alert: AlertState<Action.Alert>?
    @Presents var editingNote: EditingNote.State?
  }

  public enum Action {
    case alert(PresentationAction<Alert>)
    case addNoteButtonTapped
    case editingNote(PresentationAction<EditingNote.Action>)
    case onDelete(IndexSet)
    case noteTapped(UUID)

    public enum Alert: Equatable {}
  }

  @Dependency(\.uuid) public var uuid

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .alert:
        return .none

      case .addNoteButtonTapped:
        state.editingNote = EditingNote.State(note: Shared(Note(id: uuid(), content: "")))
        return .none

      case .editingNote(.presented(.saveButtonTapped)):
        if let note = state.editingNote?.note {
          state.notes.append(note)
        }
        return .none

      case .editingNote:
        return .none

      case let .onDelete(indexSet):
        state.notes.remove(atOffsets: indexSet)
        return .none

      case let .noteTapped(id):
        guard let note = state.$notes.elements.first(where: { $0.id == id }) else { return .none }
        state.editingNote = EditingNote.State(note: note)
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
    .ifLet(\.$editingNote, action: \.editingNote) {
      EditingNote()
    }
  }
}

// MARK: - FeedView

public struct FeedView: View {
  @Perception.Bindable public var store: StoreOf<FeedFeature>

  public var body: some View {
    WithPerceptionTracking {
      NavigationStack {
        List {
          ForEach(store.$notes.elements) { $note in
            WithPerceptionTracking {
              Text(note.content)
                .onTapGesture {
                  store.send(.noteTapped(note.id))
                }
            }
          }
          .onDelete { indexSet in
            store.send(.onDelete(indexSet))
          }
        }
        .toolbar {
          Button {
            store.send(.addNoteButtonTapped)
          } label: {
            Image(systemName: "plus")
          }
        }
      }
      .alert($store.scope(state: \.alert, action: \.alert))
      .sheet(item: $store.scope(state: \.editingNote, action: \.editingNote)) { store in
        EditingNoteView(store: store)
      }
      .navigationTitle("Notes")
    }
  }
}

// MARK: - EditingNote

@Reducer
public struct EditingNote {
  @ObservableState
  public struct State: Equatable {
    @Shared public var note: Note
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

// MARK: - EditingNoteView

struct EditingNoteView: View {
  @Perception.Bindable var store: StoreOf<EditingNote>

  var body: some View {
    WithPerceptionTracking {
      NavigationStack {
        TextEditor(text: $store.note.content)
          .navigationTitle("Edit Note")
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

// MARK: - Preview

#Preview {
  FeedView(
    store: Store(
      initialState: FeedFeature.State(
        notes: [
          Note(id: UUID(), content: "Note 1"),
          Note(id: UUID(), content: "Note 2"),
          Note(id: UUID(), content: "Note 3"),
        ]
      )
    ) {
      FeedFeature()
    }
  )
}

extension PersistenceReaderKey where Self == FileStorageKey<IdentifiedArrayOf<Note>> {
  static var notes: Self {
    fileStorage(.documentsDirectory.appending(component: "notes.json"))
  }
}

extension PersistenceReaderKey where Self == InMemoryKey<IdentifiedArrayOf<Note>> {
  static var memNotes: Self {
    inMemory("memNotes")
  }
}
