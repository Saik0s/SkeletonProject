//
// PersistenceKeys.swift
//

import ComposableArchitecture
import Foundation
import IdentifiedCollections
import Tagged

public extension PersistenceReaderKey where Self == FileStorageKey<[FeedItem]> {
  static var feedItems: Self {
    fileStorage(.documentsDirectory.appending(component: "feedItems.json"))
  }
}

public extension PersistenceReaderKey where Self == InMemoryKey<IdentifiedArrayOf<FeedItem>> {
  static var memFeedItems: Self {
    inMemory("memFeedItems")
  }
}

public extension PersistenceReaderKey where Self == FileStorageKey<UserSettings> {
  static var userSettings: Self {
    fileStorage(.documentsDirectory.appending(component: "userSettings.json"))
  }
}

public extension PersistenceReaderKey where Self == FileStorageKey<AppConfig> {
  static var appConfig: Self {
    fileStorage(.documentsDirectory.appending(component: "appConfig.json"))
  }
}
