import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:task_flow/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const storage = FlutterSecureStorage();

  // Wait until the specified text is visible.
  Future<void> waitForText(
      WidgetTester tester,
      String text, {
        int attempts = 100,
      }) async {
    for (var i = 0; i < attempts; i++) {
      await tester.pump(
        const Duration(milliseconds: 200),
      );

      if (find.text(text).evaluate().isNotEmpty) {
        return;
      }
    }

    throw TestFailure(
      'Timed out waiting for "$text"',
    );
  }

  // Login with the admin test account.
  Future<void> login(
      WidgetTester tester,
      ) async {
    await waitForText(
      tester,
      'Welcome',
    );

    final fields = find.byType(TextField);

    expect(
      fields,
      findsAtLeastNWidgets(2),
    );

    await tester.enterText(
      fields.at(0),
      'ava.admin@nimbusdigital.test',
    );

    await tester.enterText(
      fields.at(1),
      'Password123!',
    );

    FocusManager.instance.primaryFocus?.unfocus();

    await tester.pump(
      const Duration(milliseconds: 300),
    );

    final loginButton = find.text('Login');

    expect(
      loginButton,
      findsAtLeastNWidgets(1),
    );

    await tester.tap(
      loginButton.last,
      warnIfMissed: false,
    );

    await tester.pump();

    await waitForText(
      tester,
      'Quick Access',
    );
  }

  // Navigate back to the previous screen.
  Future<void> goBack(
      WidgetTester tester,
      ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    await tester.pump(
      const Duration(milliseconds: 200),
    );

    await tester.binding.handlePopRoute();

    await tester.pumpAndSettle(
      const Duration(milliseconds: 300),
    );
  }

  // Open Projects from the Quick Access card.
  Future<void> openProjects(
      WidgetTester tester,
      ) async {
    await waitForText(
      tester,
      'Quick Access',
    );

    final projectsSubtitle = find.text(
      'Manage your projects',
    );

    expect(
      projectsSubtitle,
      findsOneWidget,
    );

    await tester.tap(
      projectsSubtitle,
      warnIfMissed: false,
    );

    await tester.pump();

    await waitForText(
      tester,
      'Projects',
    );

    expect(
      find.text('Quick Access'),
      findsNothing,
    );
  }

  // Open the first available project.
  Future<void> openFirstProject(
      WidgetTester tester,
      ) async {
    await waitForText(
      tester,
      'Projects',
    );

    final inkWells = find.byType(InkWell);

    expect(
      inkWells,
      findsAtLeastNWidgets(1),
    );

    await tester.tap(
      inkWells.first,
      warnIfMissed: false,
    );

    await tester.pump();

    await waitForText(
      tester,
      'Project Details',
    );

    expect(
      find.text('Project Details'),
      findsOneWidget,
    );
  }

  // Open Tasks from the Quick Access card.
  Future<void> openTasksFromDashboard(
      WidgetTester tester,
      ) async {
    await waitForText(
      tester,
      'Quick Access',
    );

    final tasksSubtitle = find.text(
      'Manage your tasks',
    );

    expect(
      tasksSubtitle,
      findsOneWidget,
    );

    await tester.tap(
      tasksSubtitle,
      warnIfMissed: false,
    );

    await tester.pump();

    await waitForText(
      tester,
      'Tasks',
    );

    expect(
      find.text('Tasks'),
      findsAtLeastNWidgets(1),
    );

    expect(
      find.text('Quick Access'),
      findsNothing,
    );
  }

  // Open the first available task.
  Future<void> openFirstTask(
      WidgetTester tester,
      ) async {
    await waitForText(
      tester,
      'Tasks',
    );

    final inkWells = find.byType(InkWell);

    expect(
      inkWells,
      findsAtLeastNWidgets(1),
    );

    await tester.tap(
      inkWells.first,
      warnIfMissed: false,
    );

    await tester.pump();

    await waitForText(
      tester,
      'Task Details',
    );

    expect(
      find.text('Task Details'),
      findsOneWidget,
    );
  }

  // Open the profile using the dashboard profile button.
  Future<void> openProfile(
      WidgetTester tester,
      ) async {
    await waitForText(
      tester,
      'Quick Access',
    );

    final gestureDetectors = find.byType(
      GestureDetector,
    );

    expect(
      gestureDetectors,
      findsAtLeastNWidgets(1),
    );

    Finder? profileGesture;

    for (final element in gestureDetectors.evaluate()) {
      final renderObject = element.renderObject;

      if (renderObject is RenderBox) {
        final position = renderObject.localToGlobal(
          Offset.zero,
        );

        if (position.dx > 250 && position.dy < 120) {
          profileGesture = find.byElementPredicate(
                (candidate) => candidate == element,
          );
          break;
        }
      }
    }

    if (profileGesture == null) {
      throw TestFailure(
        'Could not locate dashboard profile button.',
      );
    }

    await tester.tap(
      profileGesture,
      warnIfMissed: false,
    );

    await tester.pump();

    await waitForText(
      tester,
      'Profile',
    );

    expect(
      find.text('Profile'),
      findsOneWidget,
    );
  }

  // Logout from the Profile screen.
  Future<void> logout(
      WidgetTester tester,
      ) async {
    await waitForText(
      tester,
      'Profile',
    );

    final logoutButton = find.text(
      'Logout',
    );

    expect(
      logoutButton,
      findsOneWidget,
    );

    await tester.tap(
      logoutButton,
      warnIfMissed: false,
    );

    await tester.pumpAndSettle(
      const Duration(milliseconds: 300),
    );

    final confirmLogout = find.text(
      'Yes, Logout',
    );

    if (confirmLogout.evaluate().isNotEmpty) {
      await tester.tap(
        confirmLogout,
        warnIfMissed: false,
      );

      await tester.pumpAndSettle(
        const Duration(milliseconds: 500),
      );
    }

    await waitForText(
      tester,
      'Welcome',
    );

    expect(
      find.text('Welcome'),
      findsOneWidget,
    );

    expect(
      find.text('Login'),
      findsOneWidget,
    );
  }

  testWidgets(
    'TaskFlow basic application flow',
        (tester) async {
      // Clear previous authentication state.
      await storage.deleteAll();

      // Start the application.
      app.main();

      await tester.pump();

      // Login.
      await login(tester);

      expect(
        find.text('Quick Access'),
        findsOneWidget,
      );

      // Open Projects from Quick Access.
      await openProjects(tester);

      // Open the first project.
      await openFirstProject(tester);

      expect(
        find.text('Project Details'),
        findsOneWidget,
      );

      // Return to Projects.
      await goBack(tester);

      await waitForText(
        tester,
        'Projects',
      );

      // Return to Dashboard.
      await goBack(tester);

      await waitForText(
        tester,
        'Quick Access',
      );

      // Open Tasks from Quick Access.
      await openTasksFromDashboard(tester);

      // Open the first task.
      await openFirstTask(tester);

      expect(
        find.text('Task Details'),
        findsOneWidget,
      );

      // Return to Tasks.
      await goBack(tester);

      await waitForText(
        tester,
        'Tasks',
      );

      // Return to Dashboard.
      await goBack(tester);

      await waitForText(
        tester,
        'Quick Access',
      );

      // Open Profile.
      await openProfile(tester);

      // Logout.
      await logout(tester);

      // Clear authentication state.
      await storage.deleteAll();
    },
  );
}