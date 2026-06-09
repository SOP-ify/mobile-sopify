import 'package:get/get.dart';

import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  /// Navigation is triggered in [onReady] — i.e. after the first frame is
  /// rendered — which is the reliable place to call `Get.offAllNamed` from a
  /// splash screen.
  @override
  void onReady() {
    super.onReady();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.offAllNamed(
      AuthService.to.isLoggedIn ? Routes.MAIN : Routes.LOGIN,
    );
  }
}
