//
// Entities.swift
//

import ComposableArchitecture
import SwiftUI
import Tagged

public struct FeedItem: Identifiable, Equatable, Codable {
  public let id: Tagged<Self, UUID>
  public var content: String
}
