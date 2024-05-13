//
// FeedFeatureTests.swift
//

import ComposableArchitecture
import Foundation
@testable import SkeletonProject
import XCTest

final class FeedFeatureTests: XCTestCase {
  @MainActor
  func test_sharedToRowsConversion_isSynced() async throws {
    let store = TestStore(initialState: FeedFeature.State()) {
      FeedFeature()
    } withDependencies: {
      $0.uuid = .incrementing
    }

    store.exhaustivity = .off
    await store.send(.onTask)

    @Shared(.feedItems) var items = []

    let item = FeedItem(id: .init(UUID(0)), content: "New feed item")
    await store.send(.addFeedItemButtonTapped) {
      $0.destination = .add(AddFeedItemFeature.State(feedItem: item))
    }

    await store.send(.destination(.presented(.add(.delegate(.saveButtonTapped))))) {
      $0.destination = nil
      $0.feedItems = [item]
    }

    await store.receive(\.feedItemsAmountChanged) {
      $0.rows = .init(uncheckedUniqueElements: [FeedFeature.Row.State(item: $0.$feedItems.elements.first!)])
      XCTAssertEqual($0.rows.count, 1)
    }

    store.state.$feedItems.wrappedValue.append(FeedItem(id: .init(UUID(1)), content: "New feed item"))

    await store.receive(\.feedItemsAmountChanged)

    items.append(FeedItem(id: .init(UUID(2)), content: "New feed item"))

    await store.receive(\.feedItemsAmountChanged)

    XCTAssertEqual(store.state.rows.count, 3)
    XCTAssertEqual(store.state.rows.last?.id.rawValue, UUID(2))

    items[1] = FeedItem(id: .init(UUID(3)), content: "New feed item")

    XCTAssertEqual(store.state.rows[1].id.rawValue, UUID(3))

    await store.skipInFlightEffects()
  }
}
