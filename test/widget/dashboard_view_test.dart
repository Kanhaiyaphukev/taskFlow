import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:task_flow/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:task_flow/modules/dashboard/models/response/res_dashboard.dart';
import 'package:task_flow/modules/dashboard/repositories/dashboard_repo.dart';
import 'package:task_flow/modules/dashboard/views/dashboard_view.dart';

class FakeDashboardRepository implements DashboardRepository {
  @override
  Future<ResDashboard> getDashboard() async {
    return ResDashboard(
      projects: [],
      tasks: [],
    );
  }
}

class TestDashboardController extends DashboardController {
  TestDashboardController({
    required super.repository,
  });

  @override
  // ignore: must_call_super
  void onInit() {
    // Intentionally skipped in widget test
    // to prevent automatic data loading.
  }
}

void main() {
  setUp(() {
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets(
    'Dashboard displays main sections',
        (tester) async {
      final controller = TestDashboardController(
        repository: FakeDashboardRepository(),
      );

      controller.userName.value = 'Test User';
      controller.isDataLoaded.value = true;

      Get.put<DashboardController>(controller);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: DashboardView(),
        ),
      );

      await tester.pump();

      expect(
        find.text('Hello, Test User 👋'),
        findsOneWidget,
      );

      expect(
        find.text('Here is your TaskFlow overview'),
        findsOneWidget,
      );

      expect(
        find.text('Quick Access'),
        findsOneWidget,
      );

      expect(
        find.text('Manage your projects'),
        findsOneWidget,
      );

      expect(
        find.text('Manage your tasks'),
        findsOneWidget,
      );

      expect(
        find.text('Projects'),
        findsWidgets,
      );

      expect(
        find.text('Tasks'),
        findsWidgets,
      );
    },
  );
}