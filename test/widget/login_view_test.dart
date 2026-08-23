import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:task_flow/data/dataSources/mock_data_source.dart';
import 'package:task_flow/modules/auth/bindings/auth_binding.dart';
import 'package:task_flow/modules/auth/views/login_view.dart';
import 'package:task_flow/shared/storage/flutterStorage/flutter_storage.dart';

void main() {
  setUp(() {
    Get.reset();

    Get.put(MockDataSource());
    Get.put(FlutterStorage());

    AuthBinding().dependencies();
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Login view displays required UI', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginView()));

    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);

    expect(find.text('Login to continue to TaskFlow'), findsOneWidget);

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);

    // Login screen should contain email and password fields.
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('Login view displays two input fields', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: LoginView()));

    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(2));
  });
}
