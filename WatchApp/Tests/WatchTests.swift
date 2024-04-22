//
// WatchTests.swift
//

@testable import WatchApp
import XCTest

class WatchTests: XCTestCase {
  private func dummyTest() async throws {
    XCTAssertEqual(WatchConfig.title, "Hello, watchOS")
  }
}
