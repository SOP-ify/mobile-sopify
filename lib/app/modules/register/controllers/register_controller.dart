import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final agreeTerms = false.obs;

  void toggleAgree(bool? value) => agreeTerms.value = value ?? false;

  void register() {
    // TODO: hook up registration.
  }

  void openTerms() {
    // TODO: open terms & conditions.
  }

  void goToLogin() => Get.back();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
