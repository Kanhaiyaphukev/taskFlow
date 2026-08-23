import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:task_flow/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'TaskFlow login and main navigation flow',
        (tester) async {
      app.main();

      // Initial frame.
      await tester.pump();

      // Process the splash Timer and route navigation.
      for (var i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 100));

        if (find.text('Welcome').evaluate().isNotEmpty) {
          break;
        }
      }

      // Verify Login screen.
      expect(
        find.text('Welcome'),
        findsOneWidget,
      );

      expect(
        find.text('Login to continue to TaskFlow'),
        findsOneWidget,
      );

      expect(
        find.text('Login'),
        findsOneWidget,
      );

      expect(
        find.text('Register'),
        findsOneWidget,
      );
    },
  );
}