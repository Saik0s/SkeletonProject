//
// Entities.swift
//

import Foundation
import Tagged
import MemberwiseInit

// MARK: - FeedItem

@MemberwiseInit(.public)
public struct FeedItem: Identifiable, Equatable, Codable {
  public let id: Tagged<Self, UUID>
  public var content: String
}

// MARK: - AppConfig

@MemberwiseInit(.public)
public struct AppConfig: Equatable, Codable {
  public var didCompleteOnboarding = false
}

// MARK: - UserSettings

@MemberwiseInit(.public)
public struct UserSettings: Equatable, Codable {
  public var isDarkModeEnabled = false
}
