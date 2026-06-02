import 'dart:async';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    _startSplashTimer();
  }

  void _startSplashTimer() {
    _timer = Timer(const Duration(seconds: 2), _goToLogin);
  }

  void _goToLogin() {
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
