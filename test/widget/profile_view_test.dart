import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:task_flow/modules/profile/controllers/profile_controller.dart';
import 'package:task_flow/modules/profile/models/response/res_profile.dart';
import 'package:task_flow/modules/profile/repositories/profile_repo.dart';
import 'package:task_flow/modules/profile/views/profile_view.dart';

class FakeProfileRepository implements ProfileRepository {
  @override
  Future<ResProfile> getProfile({
    required String userId,
    required String organizationId,
  }) async {
    throw UnimplementedError();
  }
}

class TestProfileController extends ProfileController {
  TestProfileController({
    required super.repository,
  });

}

void main() {
  setUp(() {
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Profile view displays unavailable state', (tester) async {
    final controller = TestProfileController(
      repository: FakeProfileRepository(),
    );

    Get.put<ProfileController>(controller);

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ProfileView(),
      ),
    );

    // Explicitly set the state AFTER the widget is mounted.
    controller.isLoading.value = false;
    controller.profile.value = null;

    await tester.pump();

    expect(
      find.text('Profile Details Not Available'),
      findsOneWidget,
    );
  });
}