//
// PersistenceKeys.swift
//

import ComposableArchitecture
import Foundation
import Tagged

public extension PersistenceReaderKey where Self == FileStorageKey<IdentifiedArrayOf<FeedItem>> {
  static var notes: Self {
    fileStorage(.documentsDirectory.appending(component: "feedItems.json"))
  }
}

public extension PersistenceReaderKey where Self == InMemoryKey<IdentifiedArrayOf<FeedItem>> {
  static var memNotes: Self {
    inMemory("memFeedItems")
  }
}

public extension PersistenceReaderKey where Self == AppStorageKey<Bool> {
  static var isDarkModeEnabled: Self {
    appStorage("isDarkModeEnabled")
  }
}
