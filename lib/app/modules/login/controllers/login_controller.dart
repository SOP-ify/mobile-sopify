import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/utils/app_dialogs.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/login_request.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthRepository _repository = Get.find<AuthRepository>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool rememberMe = false.obs;
  final RxBool isLoading = false.obs;

  void toggleRemember(bool? value) => rememberMe.value = value ?? false;

  Future<void> login() async {
    final emailError = Validators.email(emailController.text);
    if (emailError != null) {
      AppDialogs.error(emailError);
      return;
    }
    final passwordError = Validators.password(passwordController.text);
    if (passwordError != null) {
      AppDialogs.error(passwordError);
      return;
    }

    isLoading.value = true;
    try {
      final session = await _repository.login(
        LoginRequest(
          email: emailController.text.trim(),
          password: passwordController.text,
          rememberMe: rememberMe.value,
        ),
      );
      final name = session.user?.fullName ?? '';
      AppDialogs.success(
        name.isEmpty
            ? 'Anda berhasil masuk.'
            : 'Selamat datang kembali, $name!',
      );
      Get.offAllNamed(Routes.MAIN);
    } on ApiException catch (e) {
      AppDialogs.error(e.message);
    } catch (_) {
      AppDialogs.error('Terjadi kesalahan. Silakan coba lagi.');
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() => Get.toNamed(Routes.REGISTER);

  void onForgotPassword() =>
      AppDialogs.info('Fitur lupa kata sandi akan segera hadir.');

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
