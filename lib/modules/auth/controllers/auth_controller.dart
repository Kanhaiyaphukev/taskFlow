import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/routes/app_pages.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/request/req_login.dart';
import '../models/response/response_login.dart';
import '../repositories/auth_repo.dart';

class AuthController extends GetxController {
  final AuthRepository repository;
  AuthController({required this.repository});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final isLoading = false.obs;
  final loginResponse = Rxn<ResLogin>();

  /// Password visibility
  void togglePasswordVisibility() {
    obscurePassword.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.toggle();
  }

  /// Login
  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      AppToast.errorToast('Please enter email and password');
      return;
    }
    try {
      isLoading.value = true;
      final request = ReqLogin(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      final response = await repository.login(request);
      loginResponse.value = response;
      AppToast.successToast('Logged In Successfully');
      clearFields();
      await Get.offAllNamed(AppRoutes().dashboardView);
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      AppToast.errorToast(
        message.isEmpty ? 'Something went wrong. Please try again.' : message,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Registration
  Future<void> register() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      AppToast.errorToast('Please fill all fields');
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      AppToast.errorToast('Passwords do not match');
      return;
    }
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(milliseconds: 500));
      AppToast.successToast('Registration successful');
      clearFields();
      goToLogin();
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      AppToast.errorToast(
        message.isEmpty ? 'Something went wrong. Please try again.' : message,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to Register
  void goToRegister() {
    clearFields();
    Get.offNamed(AppRoutes().registerView);
  }

  /// Navigate to Login
  void goToLogin() {
    clearFields();
    Get.offNamed(AppRoutes().loginView);
  }

  /// Clear fields
  void clearFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
