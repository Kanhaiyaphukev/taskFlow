# TaskFlow Architecture

## 1. Overview

TaskFlow uses a feature-oriented layered architecture with GetX for presentation state management, dependency injection, and navigation.

The primary dependency direction is:

```text
Views
  ↓
Controllers
  ↓
Repository Interfaces
  ↓
Repository Implementations
  ↓
MockDataSource
  ↓
JSON Asset
```

The architecture keeps UI code separate from data access and gives the application a clear replacement point for a real backend.

---

## 2. High-Level Structure

```text
lib/
├── data/
│   └── dataSources/
│       └── mock_data_source.dart
│
├── modules/
│   ├── app/
│   │   ├── bindings/
│   │   ├── controllers/
│   │   └── views/
│   │
│   ├── auth/
│   │   ├── bindings/
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── repositories/
│   │   ├── services/
│   │   └── views/
│   │
│   ├── dashboard/
│   ├── profile/
│   ├── projects/
│   └── tasks/
│
└── shared/
    ├── models/
    ├── resources/
    ├── routes/
    ├── storage/
    └── widgets/
```

Each feature is organized around its responsibility instead of placing all controllers, views, and repositories into global folders.

---

## 3. Presentation Layer

### Views

Views are Flutter widgets responsible for:

- Building the screen UI
- Rendering observable controller state
- Handling user interaction
- Navigating through the application
- Showing loading/empty states

Examples:

```text
LoginView
DashboardView
ProjectView
ProjectDetailsView
TaskView
TaskDetailsView
ProfileView
SplashView
```

Views use GetX controllers through `GetView<T>` and reactive rebuilding through `Obx`.

Views do not directly load `mock-data.json`.

### Controllers

Controllers extend `GetxController` and contain presentation/business logic.

Examples:

```text
AuthController
DashboardController
ProjectController
TaskController
ProfileController
AppController
```

Controllers manage:

- Observable state
- Form fields
- Validation coordination
- Repository calls
- Loading states
- Filtering
- Authorization checks
- Navigation decisions

For example, `TaskController` owns task filtering:

```text
tasks
  ↓
applyFilters()
  ↓
filteredTasks
```

The view only renders `filteredTasks`.

---

## 4. Repository Layer

Repositories provide an abstraction between controllers and the data source.

Example:

```dart
abstract class TaskRepository {
  Future<List<ResTask>> getTasks({String? projectId});
  Future<ResTask> createTask(ReqCreateTask request);
  Future<ResTask> updateTask(String taskId, ReqUpdateTask request);
  Future<void> deleteTask(String taskId);
}
```

The implementation:

```text
TaskRepository
      ↓
TaskRepositoryImpl
      ↓
MockDataSource
```

The same pattern is used for authentication, dashboard, profile, and projects.

### Why repositories?

Repositories prevent controllers from depending directly on JSON parsing or asset loading. A future production implementation can replace:

```text
MockDataSource
```

with an HTTP/API data source while keeping most controller and view code unchanged.

---

## 5. Data Layer

`MockDataSource` is the current data source.

It loads:

```text
assets/mock_data/mock-data.json
```

using Flutter's asset bundle:

```text
rootBundle.loadString(...)
```

The JSON is parsed into maps and then converted into application models.

The data source exposes operations for:

- Login
- Token refresh
- Dashboard data
- Profile data
- Projects
- Tasks
- Organization users
- Task assignment
- Task status
- Task priority
- Create/update/delete operations

### In-memory mutations

Projects and tasks are cached in memory after their initial asset load.

Therefore:

```text
Create project
      ↓
Update in-memory project list
      ↓
Return typed response
```

and similarly for tasks.

These mutations are intentionally runtime-only and are not written back to the JSON asset.

---

## 6. Authentication Architecture

Authentication is separated into repository and session responsibilities.

```text
LoginView
   ↓
AuthController
   ↓
AuthRepository
   ↓
AuthRepositoryImpl
   ↓
MockDataSource.login()
   ↓
ResLogin
   ↓
FlutterStorage
```

The repository stores:

```text
accessToken
refreshToken
accessTokenExpiresAt
userId
userName
userAvatarUrl
organizationId
organizationName
role
```

### Session startup

```text
InitApp
   ↓
SplashView
   ↓
AppController
   ↓
AuthSessionService.checkSession()
   ↓
FlutterStorage
```

If there is no usable session:

```text
LoginView
```

If the session is valid:

```text
DashboardView
```

If the access token has expired, `AuthSessionService` attempts a mock refresh using the stored refresh token.

---

## 7. Token Lifecycle

The mock login response contains:

```text
access token
refresh token
access-token expiry information
```

The repository stores the access token and calculates an expiry timestamp 15 minutes from the login/refresh operation.

The session service checks:

```text
access token exists?
        ↓
expiry exists and is valid?
        ↓
YES → existing session is valid
NO  → attempt refresh token
        ↓
refresh succeeds → update access token/expiry
refresh fails     → clear session
```

The tokens are mock values and are not real production credentials.

---

## 8. Secure Storage

`FlutterStorage` wraps `flutter_secure_storage`.

The wrapper provides:

```text
readStorage()
writeStorage()
deleteStorage()
clearAll()
```

This keeps platform-specific secure-storage access outside controllers and views.

---

## 9. State Management

GetX is used as the application state-management solution.

### Reactive state

Controllers use:

```dart
false.obs
''.obs
Rxn<T>()
<T>[].obs
```

Views observe state using:

```dart
Obx(...)
```

Examples:

```text
isLoading
isDataLoaded
projects
tasks
filteredTasks
selectedTask
isOrgAdmin
```

### Why GetX?

GetX provides three capabilities used by this project:

1. Reactive state
2. Dependency injection
3. Navigation

This reduces boilerplate and keeps feature controllers lightweight.

---

## 10. Dependency Injection

The application has global and feature-level bindings.

### InitialBinding

Registers long-lived dependencies:

```text
MockDataSource
FlutterStorage
```

### AppBinding

Registers application/session dependencies:

```text
AuthRepository
AuthSessionService
AppController
```

### Feature bindings

Feature bindings create dependencies for:

```text
Auth
Dashboard
Profile
Projects
Tasks
```

The general flow is:

```text
Binding
  ↓
GetX dependency registration
  ↓
Controller
  ↓
Repository
  ↓
DataSource
```

This avoids manually constructing dependencies inside views.

---

## 11. Navigation

Routes are centralized in:

```text
lib/shared/routes/app_routes.dart
lib/shared/routes/app_pages.dart
```

Routes include:

```text
Splash
Login
Register
Dashboard
Profile
Projects
Project Details
Tasks
Task Details
```

GetX `GetPage` definitions connect routes to their views and bindings.

Navigation decisions are made through GetX:

```text
Get.toNamed()
Get.offNamed()
Get.offAllNamed()
Get.back()
```

---

## 12. Authorization

Role information is persisted during login.

The current application distinguishes:

```text
org_admin
member
```

Admin-only operations include project/task management operations such as:

- Create project
- Update project
- Delete project
- Create task
- Update task
- Update task status
- Update task priority
- Assign task
- Delete task

Controllers perform the authorization check before executing the operation.

This is UI/business-level authorization for the mock application; a production backend must enforce authorization server-side as well.

---

## 13. Task Filtering

`TaskController` maintains the complete task list:

```text
tasks
```

and derives the displayed list:

```text
filteredTasks
```

Supported filters:

```text
Status
Priority
Assignee
```

The filtering pipeline is:

```text
tasks
 ↓
status filter
 ↓
priority filter
 ↓
assignee filter
 ↓
filteredTasks
```

Changing or clearing a filter calls `applyFilters()`.

This keeps filtering logic out of the widget tree.

---

## 14. Validation

Shared validation logic is located in:

```text
lib/shared/widgets/regx_validator.dart
```

Controllers call validation methods before creating/updating projects and tasks.

This provides reusable validation behavior rather than duplicating regex/business rules across multiple views.

---

## 15. Loading and Error States

Controllers use observable loading flags such as:

```text
isLoading
isDataLoaded
isDetailsLoading
isFormLoading
```

Views use these flags to display loaders or normal content.

Repository/data-source failures are caught by controllers and displayed through the shared toast utility.

Examples include:

```text
Invalid email or password
User not found
Project not found
Task not found
Invalid refresh token
User does not belong to the organization
Unauthorized operation
```

---

## 16. Empty States

The project and task screens handle empty collections explicitly instead of rendering an empty list without feedback.

The project screen, for example, displays:

```text
No projects found
```

and allows pull-to-refresh.

This separates:

```text
Loading
Empty
Loaded
Error
```

states at the presentation level.

---

## 17. Mock Error and Offline Behavior

The current mock implementation does not contain a configurable network-delay/offline/error switch.

It does, however, expose failure paths through invalid input and missing entities.

Examples:

```text
Invalid login credentials
Invalid refresh token
Unknown project
Unknown task
Invalid organization membership
Invalid task assignee
```

### Current limitation

There is no dedicated mechanism such as:

```text
simulateOffline = true
simulateError = true
delay = 1000ms
```

in the current `MockDataSource`.

If a real backend is introduced, these scenarios should be represented by API/network failures and mapped into application-level error states.

---

## 18. Testing Architecture

The project contains three testing levels.

### Unit tests

Located in:

```text
test/unit/
```

These focus on isolated logic such as validation.

### Widget tests

Located in:

```text
test/widget/
```

Current widget coverage includes:

```text
Dashboard
Login
Profile
Projects
Tasks
```

Widget tests use fake repositories and test-specific controllers where necessary to isolate UI behavior from automatic data loading.

### Integration test

Located in:

```text
integration_test/app_flow_test.dart
```

The current integration test starts the real application and verifies the startup/session routing reaches the login screen when there is no active session.

The integration test is executed on a connected device using:

```bash
flutter test integration_test/app_flow_test.dart -d <device-id>
```

---

## 19. Important Testing Note

The current automated suite has been verified with:

```text
flutter analyze
No issues found!
```

and:

```text
flutter test
+15: All tests passed!
```

The integration test has also been executed successfully on a physical Android device.

The current integration test covers the startup/session-to-login flow. Additional end-to-end scenarios can be added if broader assignment-level integration coverage is required.

---

## 20. Build and Deployment

The application can be run using:

```bash
flutter pub get
flutter run
```

Release APK:

```bash
flutter build apk --release
```

Output:

```text
build/app/outputs/flutter-apk/release/
```

The current Android application ID is:

```text
com.example.taskflow
```

---

## 21. Design Decisions and Trade-offs

### Feature-first architecture

**Decision:** Keep each feature self-contained.

**Benefit:** Easier navigation, maintenance, and future team development.

**Trade-off:** There is some repetition between feature modules.

### Repository abstraction

**Decision:** Controllers depend on repository interfaces.

**Benefit:** The mock data source can later be replaced with an API implementation without coupling the UI directly to the backend.

**Trade-off:** More files and interfaces for a small assignment.

### GetX

**Decision:** Use GetX for reactive state, DI, and navigation.

**Benefit:** Low boilerplate and simple controller/view integration.

**Trade-off:** The application becomes coupled to GetX APIs.

### Mock JSON data

**Decision:** Use one assignment-provided JSON asset and a dedicated data source.

**Benefit:** Deterministic behavior and no backend dependency.

**Trade-off:** Data is not persistent across application restarts and does not represent real network behavior.

### Secure storage wrapper

**Decision:** Keep secure-storage access behind `FlutterStorage`.

**Benefit:** Controllers do not depend directly on the storage plugin and storage access is centralized.

**Trade-off:** Adds a small abstraction layer around the plugin.

---

## 22. Future Production Improvements

If TaskFlow were moved beyond the assignment/mock environment, the following would be appropriate:

1. Replace `MockDataSource` with an API data source.
2. Add real HTTP authentication and refresh endpoints.
3. Add server-side authorization.
4. Add explicit network/offline error mapping.
5. Add configurable retry behavior.
6. Add persistent caching where required.
7. Add repository-level API tests.
8. Expand integration coverage to complete user workflows.
9. Add secure token rotation and production session policies.
10. Add CI checks for analyze, tests, and release builds.
