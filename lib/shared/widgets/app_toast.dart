import 'dart:ui';
import 'package:get/get.dart';
import '../resources/styles/app_colors.dart';

class AppToast {
  AppToast._();

  static void successToast(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: AppColors.withOpacity(AppColors.dashboardCardBg, 1),
      colorText: AppColors.textColor,
      duration: const Duration(seconds: 3),
    );
  }

  static void generalToast({
    required String title,
    required String message,
    Color? backgroundColor,
    Color? textColor,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.withOpacity(AppColors.dashboardCardBg, 1),
      colorText: AppColors.textColor,
      duration: const Duration(seconds: 3),
    );
  }

  static void errorToast(String message) {
    Get.snackbar(
      'Failed',
      message,
      backgroundColor: AppColors.withOpacity(AppColors.dashboardCardBg, 1),
      colorText: AppColors.textColor,
      duration: const Duration(seconds: 3),
    );
  }
}
