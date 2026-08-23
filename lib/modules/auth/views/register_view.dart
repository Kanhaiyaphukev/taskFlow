import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/routes/app_pages.dart';
import '../../../shared/storage/flutterStorage/flutter_storage.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_text_button.dart';
import '../../../shared/resources/styles/app_colors.dart';
import '../../../shared/resources/styles/app_space_between.dart';
import '../../../shared/resources/styles/app_text_style.dart';
import '../../../shared/widgets/custom_elevated_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/dialogs.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: '',
          onBack: () async {
            await showPauseDialog();
          },
        ),
        backgroundColor: AppColors.bgColor,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/png/task_flow_logo_horizontal.png',
                                height: 80,
                              ),
                              gapH24,
                              Text(
                                'Create Account',
                                textAlign: TextAlign.center,
                                style: AppTextStyle.titleRegular(
                                  color: AppColors.textColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              gapH8,
                              Text(
                                'Register to continue to TaskFlow',
                                textAlign: TextAlign.center,
                                style: AppTextStyle.titleRegular(
                                  color: AppColors.withOpacity(
                                    AppColors.textColor,
                                    0.6,
                                  ),
                                  fontSize: 14,
                                ),
                              ),
                              gapH48,
                              CustomTextField(
                                controller: controller.nameController,
                                labelText: 'Name',
                                hintText: 'Enter your name',
                                keyboardType: TextInputType.name,
                                height: 60,
                                contentPaddingHorizontal: 18,
                              ),
                              gapH20,
                              CustomTextField(
                                controller: controller.emailController,
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                keyboardType: TextInputType.emailAddress,
                                height: 60,
                                contentPaddingHorizontal: 18,
                              ),
                              gapH20,
                              CustomTextField(
                                controller: controller.passwordController,
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                obscureText: true,
                                height: 60,
                                contentPaddingHorizontal: 18,
                              ),
                              gapH20,
                              CustomTextField(
                                controller:
                                    controller.confirmPasswordController,
                                labelText: 'Confirm Password',
                                hintText: 'Confirm your password',
                                obscureText: true,
                                height: 60,
                                contentPaddingHorizontal: 18,
                              ),
                              gapH32,
                            ],
                          ),
                        ),
                      ),
                    ),
                    gapH16,
                    Obx(
                      () => CustomElevatedButton(
                        text: 'Register',
                        textColor: AppColors.black,
                        backgroundColor: AppColors.primary,
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.register,
                      ),
                    ),
                    gapH12,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: AppTextStyle.titleRegular(
                            color: AppColors.withOpacity(
                              AppColors.textColor,
                              0.6,
                            ),
                            fontSize: 14,
                          ),
                        ),
                        CustomTextButton(
                          onPressed: controller.goToLogin,
                          text: 'Login',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Obx(
                () => controller.isLoading.value
                    ? Container(
                        color: AppColors.bgColor,
                        child: AppLoader.circularLoader(),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showPauseDialog() async {
    return await Dialogs().stopRegistrationConfirm(
      onStop: () async {
        AppToast.successToast(
          'Registration paused. You can finish your profile setup later.',
        );
        await Get.find<FlutterStorage>().clearAll();
        await Get.offAllNamed(AppRoutes().loginView);
      },
    );
  }
}
