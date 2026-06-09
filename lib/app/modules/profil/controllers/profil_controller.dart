import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/utils/app_dialogs.dart';
import '../../../data/models/update_profile_request.dart';
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
  final RxBool isSaving = false.obs;
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

  Future<bool> saveProfile({
    required String fullName,
    required String jabatan,
  }) async {
    isSaving.value = true;
    try {
      await _userRepo.updateProfile(
        UpdateProfileRequest(
          fullName: fullName.trim().isEmpty ? null : fullName.trim(),
          jabatan: jabatan.trim().isEmpty ? null : jabatan.trim(),
        ),
      );
      AppDialogs.success('Profil berhasil diperbarui.');
      return true;
    } on ApiException catch (e) {
      AppDialogs.error(e.message);
      return false;
    } catch (_) {
      AppDialogs.error('Gagal memperbarui profil.');
      return false;
    } finally {
      isSaving.value = false;
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
