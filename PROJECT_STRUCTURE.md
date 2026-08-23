# Project Structure: taskFlow

This document provides an overview of the directory structure and organization of the **taskFlow** project.

## Project Root
- **android/**: Android-specific source code and configuration.
- **assets/**: Application assets like images, fonts, and data files.
- **ios/**: iOS-specific source code and configuration.
- **lib/**: The core Flutter application source code.
- **test/**: Unit and widget tests.
- **web/**, **linux/**, **macos/**, **windows/**: Platform-specific directories for web and desktop support.
- **pubspec.yaml**: Manages dependencies, assets, and project metadata.
- **analysis_options.yaml**: Configuration for the Dart analyzer and linter.

---

## lib/ Directory
The `lib/` directory follows a modular architecture:

### modules/
Contains feature-specific code. Each folder represents a distinct functional area of the app:
- **app/**: Base application setup and global state management.
- **auth/**: Authentication flows (login, signup, etc.).
- **dashboard/**: Overview and main landing screen logic.
- **profile/**: User profile settings and details.
- **projects/**: Logic and UI for managing projects.
- **tasks/**: Logic and UI for task management.

### data/
Handles data retrieval and persistence:
- **dataSources/**: Implementation of remote (API) and local (Database/Cache) data sources.

### shared/
Reusable components and utilities shared across multiple modules:
- **models/**: Data models and entities.
- **resources/**: Themes, colors, strings, and other constants.
- **routes/**: App navigation and routing configuration.
- **storage/**: Helpers for local data storage (e.g., SharedPreferences, Hive).
- **widgets/**: Common UI components (buttons, text fields, etc.).

### main.dart
The entry point of the Flutter application.

---

## android/ Directory
- **app/**: Contains the Android application module.
  - **src/main/kotlin/com/example/taskflow/**: Includes `MainActivity.kt`.
- **gradle/**: Contains the Gradle Wrapper files.
- **build.gradle.kts**: Project-level build configuration.
- **settings.gradle.kts**: Module and repository definitions.

---

## ios/ Directory
- **Runner/**: The main iOS application target.
- **Runner.xcodeproj**: Xcode project file.
- **Runner.xcworkspace**: Xcode workspace file.
- **Flutter/**: Flutter-related framework and configuration.
