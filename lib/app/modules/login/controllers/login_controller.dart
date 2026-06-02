import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final rememberMe = false.obs;

  void toggleRememberMe(bool? value) => rememberMe.value = value ?? false;

  void login() {
    // TODO: hook up authentication.
  }

  void forgotPassword() {
    // TODO: navigate to forgot password flow.
  }

  void goToRegister() => Get.toNamed(Routes.REGISTER);

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
