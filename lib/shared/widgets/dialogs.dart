import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../resources/styles/app_colors.dart';
import '../resources/styles/app_space_between.dart';
import '../resources/styles/app_text_style.dart';
import 'custom_button_for_dialogs.dart';

class Dialogs extends GetxController {
  Future logoutConfirm({required Function onLogout}) {
    return Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.dashboardCardBg,
        surfaceTintColor: AppColors.dashboardCardBg,
        contentPadding: const EdgeInsets.all(20),
        content: SizedBox(
          height: MediaQuery.of(Get.context!).size.height * 0.40,
          width: MediaQuery.of(Get.context!).size.width * 0.30,
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/png/logout.png',
                  height: MediaQuery.of(Get.context!).size.height * 0.13,
                  width: MediaQuery.of(Get.context!).size.width * 0.21,
              errorBuilder: (_, _, _) => Icon(
                Icons.logout,
                size: 40,
                color: AppColors.primary,
              ),
                ),
                gapH4,
                Text(
                  'Logout!',
                  style: AppTextStyle.titleRegular(),
                  maxLines: 2,
                ),
                gapH12,
                Text(
                  'Are you sure you want to logout?',
                  style: AppTextStyle.titleRegular(),
                  textAlign: TextAlign.center,
                  maxLines: 5,
                ),
                gapH20,
                CustomButtonForDialogs(
                  title: 'Yes, Logout',
                  onPressed: () => onLogout(),
                  textColor: AppColors.textColor,
                ),
                gapH12,
                CustomButtonForDialogs(
                  title: 'Keep Login',
                  onPressed: () => closeLoader(),
                  backgroundColor: AppColors.withOpacity(AppColors.grey, 0.2),
                  textColor: AppColors.textColor,
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void closeLoader() {
    Get.back();
  }

  Future stopRegistrationConfirm({required Function onStop}) {
    return Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.dashboardCardBg,
        surfaceTintColor: AppColors.dashboardCardBg,
        contentPadding: const EdgeInsets.all(20),
        content: SizedBox(
          height: MediaQuery.of(Get.context!).size.height * 0.40,
          width: MediaQuery.of(Get.context!).size.width * 0.30,
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/png/logout.png',
                  height: MediaQuery.of(Get.context!).size.height * 0.13,
                  width: MediaQuery.of(Get.context!).size.width * 0.21,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.logout,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                gapH4,
                Text(
                  'Pause Process!',
                  style: AppTextStyle.titleRegular(),
                  maxLines: 2,
                ),
                gapH12,
                Text(
                  'Are you sure you want to pause registration process?',
                  style: AppTextStyle.titleRegular(),
                  textAlign: TextAlign.center,
                  maxLines: 5,
                ),
                gapH20,
                CustomButtonForDialogs(
                  title: 'Yes',
                  onPressed: () => onStop(),
                  textColor: AppColors.textColor,
                ),
                gapH12,
                CustomButtonForDialogs(
                  title: 'No',
                  onPressed: () => closeLoader(),
                  backgroundColor: AppColors.withOpacity(AppColors.grey, 0.2),
                  textColor: AppColors.textColor,
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future deleteConfirm({
    required String title,
    required String message,
    required Function onDelete,
  }) {
    return Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.dashboardCardBg,
        surfaceTintColor: AppColors.dashboardCardBg,
        contentPadding: const EdgeInsets.all(20),
        content: SizedBox(
          height: MediaQuery.of(Get.context!).size.height * 0.40,
          width: MediaQuery.of(Get.context!).size.width * 0.30,
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/png/delete.png',
                  height: MediaQuery.of(Get.context!).size.height * 0.13,
                  width: MediaQuery.of(Get.context!).size.width * 0.21,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.delete_outline,
                    size: 40,
                    color: AppColors.red,
                  ),
                ),
                gapH4,
                Text(
                  title,
                  style: AppTextStyle.titleRegular(),
                  maxLines: 2,
                ),
                gapH12,
                Text(
                  message,
                  style: AppTextStyle.titleRegular(),
                  textAlign: TextAlign.center,
                  maxLines: 5,
                ),
                gapH20,
                CustomButtonForDialogs(
                  title: 'Yes, Delete',
                  onPressed: () => onDelete(),
                  textColor: AppColors.textColor,
                ),
                gapH12,
                CustomButtonForDialogs(
                  title: 'Cancel',
                  onPressed: closeLoader,
                  backgroundColor: AppColors.withOpacity(
                    AppColors.grey,
                    0.2,
                  ),
                  textColor: AppColors.textColor,
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
