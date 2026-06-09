import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/utils/app_dialogs.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/register_request.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/terms_dialog.dart';

class RegisterController extends GetxController {
  final AuthRepository _repository = Get.find<AuthRepository>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool agreeToTerms = false.obs;
  final RxBool isLoading = false.obs;

  void toggleAgree(bool? value) => agreeToTerms.value = value ?? false;

  void openTerms() => TermsDialog.show();

  Future<void> register() async {
    final nameError = Validators.fullName(nameController.text);
    if (nameError != null) {
      AppDialogs.error(nameError);
      return;
    }
    final emailError = Validators.email(emailController.text);
    if (emailError != null) {
      AppDialogs.error(emailError);
      return;
    }
    final phoneError = Validators.phone(phoneController.text);
    if (phoneError != null) {
      AppDialogs.error(phoneError);
      return;
    }
    final passwordError = Validators.password(passwordController.text);
    if (passwordError != null) {
      AppDialogs.error(passwordError);
      return;
    }
    if (!agreeToTerms.value) {
      AppDialogs.error('Anda harus menyetujui Syarat dan Ketentuan.');
      return;
    }

    isLoading.value = true;
    try {
      await _repository.register(
        RegisterRequest(
          fullName: nameController.text.trim(),
          email: emailController.text.trim(),
          phoneNumber: phoneController.text.trim(),
          password: passwordController.text,
          agreeToTerms: agreeToTerms.value,
        ),
      );
      AppDialogs.success('Registrasi berhasil. Selamat datang di SOP-ify!');
      Get.offAllNamed(Routes.MAIN);
    } on ApiException catch (e) {
      AppDialogs.error(e.message);
    } catch (_) {
      AppDialogs.error('Terjadi kesalahan. Silakan coba lagi.');
    } finally {
      isLoading.value = false;
    }
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
