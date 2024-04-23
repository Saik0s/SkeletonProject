//
// Entities.swift
//

import Foundation
import Tagged

// MARK: - FeedItem

public struct FeedItem: Identifiable, Equatable, Codable {
  public let id: Tagged<Self, UUID>
  public var content: String
}

// MARK: - AppConfig

public struct AppConfig: Equatable, Codable {
  public var didCompleteOnboarding = false
}

// MARK: - UserSettings

public struct UserSettings: Equatable, Codable {
  public var isDarkModeEnabled = false
}
