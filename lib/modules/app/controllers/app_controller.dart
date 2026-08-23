import 'dart:async';

import 'package:get/get.dart';

import '../../../shared/routes/app_pages.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../auth/services/auth_session_service.dart';

class AppController extends GetxController {
  final RxDouble progress = 0.0.obs;
  final AuthSessionService authSessionService = Get.find<AuthSessionService>();

  @override
  void onInit() {
    super.onInit();
    _startProgress();
  }

  /// Start splash progress
  void _startProgress() {
    const totalDuration = Duration(milliseconds: 1500);
    const tickInterval = Duration(milliseconds: 30);

    final totalTicks =
        totalDuration.inMilliseconds ~/ tickInterval.inMilliseconds;
    int tick = 0;
    Timer.periodic(tickInterval, (timer) async {
      tick++;
      progress.value = tick / totalTicks;

      if (tick >= totalTicks) {
        timer.cancel();
        await checkLocalData();
      }
    });
  }

  /// Check local authentication data
  Future<void> checkLocalData() async {
    try {
      final hasSession = await authSessionService.checkSession();

      if (hasSession) {
        await Get.offAllNamed(AppRoutes().dashboardView);
        return;
      }

      await Get.offAllNamed(AppRoutes().loginView);
    } catch (e) {
      await authSessionService.clearSession();

      AppToast.errorToast('Something went wrong. Please login again.');

      await Get.offAllNamed(AppRoutes().loginView);
    }
  }
}
