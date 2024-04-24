# SkeletonProject: An iOS Example Application with Composable Architecture

SkeletonProject is an iOS example application that demonstrates the implementation of common features and scenarios using the Composable Architecture (TCA) from Point-Free. This project serves as a reference and learning resource for developers looking to understand and apply the principles of TCA in their iOS applications.

<div align="center">
  <h2 style="font-size: 1.5em;">🚧 Work in Progress 🚧</h2>
</div>

## Features

The SkeletonProject application showcases the following features:

1. **Splash Screen**: Displays a splash screen with a countdown timer when the app launches, transitioning to the main screen after a short delay.

2. **Tab-based Navigation**: Implements a tab-based navigation system with two tabs: "Feed" and "Settings".

3. **Feed Tab**:
   - Displays a list of feed items in a scrollable view.
   - Allows users to add new feed items.
   - Enables users to edit and delete existing feed items.
   - Provides a details screen to view and edit the content of a selected feed item.

4. **Settings Tab**: Provides a settings screen for configuring app preferences, such as enabling dark mode.

5. **Onboarding Flow**: Demonstrates an onboarding flow for first-time users.

6. **Data Persistence**: Persists feed items and user settings across app launches using file storage.

7. **Error Handling and Loading States**: Handles error scenarios gracefully and displays appropriate error messages and loading indicators.

## Implementation

The SkeletonProject application is built using the Composable Architecture (TCA) from Point-Free, which is a state management and architecture pattern for SwiftUI applications. TCA promotes a unidirectional data flow and separates concerns between state management, view rendering, and side effects.

The application is structured into several features, each representing a specific functionality or screen. Each feature is implemented as a separate module, following the principles of TCA.

### Core Components

1. **AppFeature**: The root feature that manages the application's state and coordinates the transitions between the splash screen and the main screen.

2. **MainFeature**: Handles the tab-based navigation and manages the state of the "Feed" and "Settings" tabs.

3. **FeedFeature**: Responsible for managing the state of the feed items, including adding, editing, deleting, and displaying details.

4. **UserSettingsFeature**: Manages the user settings, such as enabling or disabling dark mode.

5. **SplashFeature**: Implements the splash screen functionality with a countdown timer.

6. **OnboardingFeature**: Handles the onboarding flow for first-time users.

### State Management

The application's state is managed using the `@Reducer` and `@ObservableState` constructs provided by TCA. Each feature has its own state and reducer, which defines how the state should be updated in response to user actions or side effects.

### Side Effects

Side effects, such as network requests, data persistence, and navigation, are handled using the `@Dependency` and `@Effect` constructs provided by TCA. This separation of concerns allows for better testability and maintainability of the codebase.

### Data Persistence

The application uses file storage to persist feed items and user settings across app launches. The `@Shared` property wrapper from TCA is used to manage the shared state between different features.

### Error Handling and Loading States

Error handling and loading states are implemented using the `@Reducer` and `@ObservableState` constructs from TCA. Appropriate error messages and loading indicators are displayed to the user based on the application's state.

## Getting Started

To run the SkeletonProject application, follow these steps:

1. Clone the repository: `gh repo clone Saik0s/SkeletonProject` or `git clone https://github.com/Saik0s/SkeletonProject.git`
2. Run `make`
3. Open generated `SkeletonProject.xcworkspace` and run the project

## License

The SkeletonProject is released under the [MIT License](LICENSE).
