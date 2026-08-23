import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/resources/styles/app_colors.dart';
import '../../../shared/resources/styles/app_space_between.dart';
import '../../../shared/resources/styles/app_text_style.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/custom_elevated_button.dart';
import '../../../shared/widgets/custom_text_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    gapH32,
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/png/task_flow_logo_horizontal.png',
                                height: 80,
                              ),
                              gapH32,
                              Text(
                                'Welcome',
                                textAlign: TextAlign.center,
                                style: AppTextStyle.titleRegular(
                                  color: AppColors.textColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              gapH8,
                              Text(
                                'Login to continue to TaskFlow',
                                textAlign: TextAlign.center,
                                style: AppTextStyle.titleRegular(
                                  color: AppColors.withOpacity(
                                    AppColors.textColor,
                                    0.6,
                                  ),
                                  fontSize: 14,
                                ),
                              ),
                              gapH64,
                              CustomTextField(
                                controller: controller.emailController,
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                keyboardType: TextInputType.emailAddress,
                                height: 60,
                                contentPaddingHorizontal: 18,
                              ),
                              gapH24,
                              Obx(
                                    () => CustomTextField(
                                  controller:
                                  controller.passwordController,
                                  labelText: 'Password',
                                  hintText: 'Enter your password',
                                  height: 60,
                                  contentPaddingHorizontal: 18,
                                  obscureText:
                                  controller.obscurePassword.value,
                                  suffixIcon: IconButton(
                                    onPressed:
                                    controller.togglePasswordVisibility,
                                    icon: Icon(
                                      controller.obscurePassword.value
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 18,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ),
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
                        text: 'Login',
                        textColor: AppColors.black,
                        backgroundColor: AppColors.primary,
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.login,
                      ),
                    ),
                    gapH20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTextStyle.titleRegular(
                            color: AppColors.withOpacity(
                              AppColors.textColor,
                              0.6,
                            ),
                            fontSize: 14,
                          ),
                        ),
                        CustomTextButton(
                          onPressed: controller.goToRegister,
                          text: 'Register',
                        ),
                      ],
                    ),
                    gapH12,
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
}