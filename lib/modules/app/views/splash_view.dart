import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/resources/styles/app_colors.dart';
import '../../../shared/resources/styles/app_space_between.dart';
import '../../../shared/resources/styles/app_text_style.dart';
import '../controllers/app_controller.dart';

class SplashView extends GetView<AppController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/png/task_flow_logo_horizontal.png',
                      height: 90,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.task,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                    gapH24,
                    Text(
                      'Manage your work. Stay organized.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.withOpacity(
                          AppColors.textColor,
                          0.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 48,
                child: Obx(() {
                  final pct =
                  (controller.progress.value * 100).toInt();
                  return Column(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Loading...',
                              style: AppTextStyle.titleRegular(
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '$pct%',
                              style: AppTextStyle.titleRegular(
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      gapH8,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: controller.progress.value,
                          minHeight: 4,
                          backgroundColor: AppColors.white,
                          valueColor:
                          const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}