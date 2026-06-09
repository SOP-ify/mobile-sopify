import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class ProfilController extends GetxController {
  final UserRepository _userRepo = Get.find<UserRepository>();
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  final AuthService _auth = AuthService.to;

  final RxBool isLoading = false.obs;
  final RxBool isLoggingOut = false.obs;
  final RxString error = ''.obs;
  final RxInt totalSop = 0.obs;

  Rxn<UserModel> get user => _auth.currentUser;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      await _userRepo.getProfile();
      final summary = await _userRepo.getSummary();
      totalSop.value = summary.totalSop;
    } on ApiException catch (e) {
      error.value = e.message;
    } catch (_) {
      error.value = 'Gagal memuat profil. Tarik untuk menyegarkan.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoggingOut.value = true;
    try {
      await _authRepo.logout();
    } catch (_) {
      // Even if the network logout fails, the session has been cleared locally.
    } finally {
      isLoggingOut.value = false;
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
