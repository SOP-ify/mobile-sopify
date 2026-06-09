import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/sop_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../home/controllers/home_controller.dart';
import '../../profil/controllers/profil_controller.dart';
import '../../riwayat/controllers/riwayat_controller.dart';
import '../controllers/botnavbar_controller.dart';

/// Registers the shell controller and every tab controller so the tabs are
/// ready the moment the [IndexedStack] builds them.
class BotNavBarBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure the repositories the tab controllers depend on exist, even if the
    // user reached this route via a hot reload that skipped `main()`. These are
    // no-ops when the repos are already registered globally.
    if (!Get.isRegistered<AuthRepository>()) {
      Get.put<AuthRepository>(AuthRepository(), permanent: true);
    }
    if (!Get.isRegistered<UserRepository>()) {
      Get.put<UserRepository>(UserRepository(), permanent: true);
    }
    if (!Get.isRegistered<SopRepository>()) {
      Get.put<SopRepository>(SopRepository(), permanent: true);
    }

    Get.lazyPut<BotNavBarController>(() => BotNavBarController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<RiwayatController>(() => RiwayatController());
    Get.lazyPut<ProfilController>(() => ProfilController());
  }
}
