# Arch Notes

This is an iOS example application that demonstrates common scenarios developers face when building apps.

## Features

1. Feed
   - Display a list of items
   - Add new items
   - Edit existing items
   - Delete items
   - Open item details

2. Settings
   - Persist settings across app launches
   - Access settings from different parts of the app

3. Tab-based Navigation
   - Switch between different tabs (e.g., Feed, Settings)

4. Stack-based Navigation
   - Navigate between screens within a tab

5. Settings
   - Provide app-wide settings
   - Persist settings across app launches

6. Onboarding
   - Show an onboarding flow for first-time users

7. Splash Screen
   - Display a splash screen while the app is loading

8. Persistence
   - Store data locally

## Architecture

- [Composable Architecture (TCA)](https://github.com/pointfreeco/swift-composable-architecture) for state management
- [Dependencies](https://github.com/pointfreeco/swift-dependencies) lib for dependency injection

## Data Persistence

- Local persistence using simple file storage (e.g., JSON, Plist) via new Shared property wrapper in TCA
