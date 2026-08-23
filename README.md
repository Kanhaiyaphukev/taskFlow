# TaskFlow

TaskFlow is a Flutter project and task management application built for the Flutter assignment. It provides authentication, dashboard overview, project management, task management, task assignment, filtering, profile management, and role-based actions using a local mock data source.

## Features

- Login with mock credentials
- Registration UI flow
- Persistent authentication/session data using `flutter_secure_storage`
- Short-lived access-token simulation with refresh-token flow
- Splash/session check before entering the application
- Dashboard with project/task overview
- Project listing, details, create, update, and delete flows
- Task listing and task details
- Task creation and update
- Task status and priority updates
- Task assignment/unassignment
- Task filtering by status, priority, and assignee
- Profile and organization information
- Organization-admin authorization checks
- Loading, empty, validation, and error states
- Pull-to-refresh for project and task lists
- Reusable widgets and centralized styling
- Unit, widget, and integration tests

## Tech Stack

- Flutter
- Dart
- GetX for state management, dependency injection, and navigation
- `flutter_secure_storage` for local authentication/session storage
- JSON asset-based mock data
- Material 3
- `google_fonts`
- `http` and related networking packages are included for the project stack, while the current assignment data flow uses the mock data source

### SDK

The project requires Dart SDK `^3.13.1`.

The project metadata uses the Flutter **stable** channel. For the exact Flutter SDK version used on a particular machine, run:

```bash
flutter --version
```

## Architecture

TaskFlow follows a feature-oriented layered architecture:

```text
View
  ↓
GetX Controller
  ↓
Repository Interface
  ↓
Repository Implementation
  ↓
MockDataSource
  ↓
assets/mock_data/mock-data.json
```

Views are responsible for UI composition. Controllers contain presentation/business logic and expose reactive state. Repositories abstract data operations from controllers. `MockDataSource` loads and mutates in-memory mock data.

Authentication has an additional session layer:

```text
LoginView
  ↓
AuthController
  ↓
AuthRepository
  ↓
MockDataSource
  ↓
FlutterStorage
```

On application startup:

```text
SplashView
  ↓
AppController
  ↓
AuthSessionService
  ↓
FlutterStorage
  ↓
Login or Dashboard
```

See [ARCHITECTURE.md](ARCHITECTURE.md) for the detailed design.

## Project Structure

```text
taskFlow/
├── assets/
│   ├── images/
│   └── mock_data/
│       └── mock-data.json
├── integration_test/
│   └── app_flow_test.dart
├── lib/
│   ├── data/
│   │   └── dataSources/
│   │       └── mock_data_source.dart
│   ├── modules/
│   │   ├── app/
│   │   ├── auth/
│   │   ├── dashboard/
│   │   ├── profile/
│   │   ├── projects/
│   │   └── tasks/
│   ├── shared/
│   │   ├── models/
│   │   ├── resources/
│   │   ├── routes/
│   │   ├── storage/
│   │   └── widgets/
│   └── main.dart
├── test/
│   ├── unit/
│   └── widget/
├── ARCHITECTURE.md
├── PROJECT_STRUCTURE.md
├── pubspec.yaml
└── README.md
```

Each feature module generally contains:

```text
bindings/
controllers/
models/
repositories/
views/
```

## Mock Data

The application uses:

```text
assets/mock_data/mock-data.json
```

The UI does not read the JSON file directly. `MockDataSource` loads the asset with Flutter's asset bundle, parses the JSON, and exposes typed operations to repository implementations.

The mock data contains:

- Organizations
- Users
- Organization memberships
- Projects
- Tasks
- Comments
- Notifications
- Test authentication credentials
- Mock access/refresh tokens

Project and task collections are loaded into memory by `MockDataSource`, allowing create/update/delete operations to affect the running application state.

### Important limitation

The current `MockDataSource` does **not** implement an artificial network delay or a configurable offline/error switch. Error paths are represented through validation and missing/invalid entity cases, such as invalid credentials, invalid refresh tokens, missing projects/tasks, and invalid task assignment.

## Authentication and Session Flow

The login flow is:

1. User enters email and password.
2. `AuthController` validates required fields.
3. `AuthRepositoryImpl` calls `MockDataSource.login()`.
4. Mock credentials are matched against `auth_mock.test_credentials`.
5. The mock response returns user, organization, membership, access-token, and refresh-token data.
6. The repository stores session information using `FlutterStorage`.
7. The application navigates to the dashboard.

Stored session information includes:

- Access token
- Refresh token
- Access-token expiry timestamp
- User ID
- User name
- Avatar URL
- Organization ID/name
- Role

At startup, `AuthSessionService` checks the access token. If it is expired and a refresh token exists, it requests a new mock access token and updates the expiry timestamp. If refresh fails, the session is cleared and the user is returned to login.

## Test Credentials

The mock data contains both organization-admin and member accounts.

### Organization Admin

```text
Email: ava.admin@nimbusdigital.test
Password: Password123!
Organization: Nimbus Digital
Role: org_admin
```

### Organization Member

```text
Email: marcus.member@nimbusdigital.test
Password: Password123!
Organization: Nimbus Digital
Role: member
```

Additional credentials are available in `assets/mock_data/mock-data.json`.

## State Management

GetX is used for:

- Reactive state with `Rx`, `Rxn`, and observable collections
- Controllers for screen/business logic
- Dependency injection through Bindings
- Route navigation
- Reactive UI updates through `Obx`

For example, task state is maintained in `TaskController`, including:

- Loading state
- Loaded state
- Task collection
- Filtered task collection
- Selected task
- Form state
- Role/authorization state

Filtering is applied in the controller rather than in the view.

## Dependency Injection

Global dependencies are registered through `InitialBinding`, including:

- `MockDataSource`
- `FlutterStorage`

Feature-specific dependencies are registered through GetX bindings such as:

- `AuthBinding`
- `DashboardBinding`
- `ProjectBinding`
- `TaskBinding`
- `ProfileBinding`
- `AppBinding`

This keeps construction and dependency wiring outside the views.

## Validation and Error Handling

Input validation is centralized in `RegexValidator` and used by project/task forms.

Controllers handle repository/data-source failures with user-facing toast messages and maintain loading states using `try/catch/finally`.

Examples of handled errors include:

- Invalid login credentials
- Missing user/organization/membership
- Invalid refresh token
- Project not found
- Task not found
- Unauthorized organization-member actions
- Invalid task assignment
- Invalid form input

## Running the Project

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

For a specific device:

```bash
flutter devices
flutter run -d <device-id>
```

## Testing

Run all unit and widget tests:

```bash
flutter test
```

Run unit tests:

```bash
flutter test test/unit
```

Run widget tests:

```bash
flutter test test/widget
```

Run the integration test on a connected Android device:

```bash
flutter test integration_test/app_flow_test.dart -d <device-id>
```

The current integration test verifies application startup, splash/session routing, and the login screen.

## Static Analysis

```bash
flutter analyze
```

The project was verified with:

```text
No issues found!
```

## Build APK

Build a release APK with:

```bash
flutter build apk --release
```

The generated APK is produced under:

```text
build/app/outputs/flutter-apk/release/
```

## Testing Status

The current project includes:

- Unit tests for validation logic
- Widget tests for login, dashboard, profile, project, and task views
- An integration test for the startup/session-to-login flow
- Static analysis with no analyzer issues

The final automated test suite currently passes with:

```text
+15: All tests passed!
```

## Known Limitations

- The application currently uses local mock JSON data instead of a real backend.
- There is no real network/API authentication.
- The mock data source does not currently provide a configurable artificial delay/offline toggle.
- In-memory project/task mutations are reset when the application process is restarted.
- The exact Flutter SDK patch version should be recorded with `flutter --version` when reproducing the assignment environment.

## Design Decisions

### Feature-first organization

Feature modules keep authentication, dashboard, projects, tasks, and profile code separated and easier to maintain.

### Repository abstraction

Controllers depend on repository interfaces instead of directly accessing the data source. This keeps the presentation layer independent from the current mock implementation and makes a real API implementation easier to introduce later.

### GetX

GetX was selected because it provides reactive state, dependency injection, and navigation with relatively little boilerplate and fits the feature/controller structure of the application.

### Mock data source

The mock data source provides deterministic assignment data without requiring a backend server. It also allows repository interfaces to remain close to how a production data layer would be structured.

## Submission Checklist

Before submission:

```bash
flutter analyze
flutter test
flutter build apk --release
```

Also verify:

- Git working tree is clean
- README and architecture documentation are committed
- Test credentials are documented
- Release APK builds successfully
- The repository does not contain generated build artifacts or secrets
