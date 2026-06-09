import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/utils/app_dialogs.dart';
import '../../../data/models/update_profile_request.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/services/auth_service.dart';

/// Drives the dedicated "Edit Profil" page. Only `full_name`, `username` and
/// `jabatan` are editable — `PUT /api/v1/user/me` accepts nothing else, so email
/// and phone number are shown read-only.
class EditProfileController extends GetxController {
  final UserRepository _userRepo = Get.find<UserRepository>();
  final AuthService _auth = AuthService.to;

  final TextEditingController fullNameC = TextEditingController();
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController jabatanC = TextEditingController();

  final RxBool isSaving = false.obs;

  String fullName = '';
  String email = '-';
  String phoneNumber = '-';

  @override
  void onInit() {
    super.onInit();
    final user = _auth.currentUser.value;
    fullName = user?.fullName ?? '';
    fullNameC.text = user?.fullName ?? '';
    usernameC.text = user?.username ?? '';
    jabatanC.text = user?.jabatan ?? '';
    email = (user?.email.isNotEmpty ?? false) ? user!.email : '-';
    phoneNumber =
        (user?.phoneNumber?.isNotEmpty ?? false) ? user!.phoneNumber! : '-';
  }

  @override
  void onClose() {
    fullNameC.dispose();
    usernameC.dispose();
    jabatanC.dispose();
    super.onClose();
  }

  Future<void> save() async {
    if (isSaving.value) return;

    final name = fullNameC.text.trim();
    if (name.isEmpty) {
      AppDialogs.error('Nama lengkap tidak boleh kosong.');
      return;
    }

    final username = usernameC.text.trim();
    final jabatan = jabatanC.text.trim();

    isSaving.value = true;
    try {
      await _userRepo.updateProfile(
        UpdateProfileRequest(
          fullName: name,
          username: username.isEmpty ? null : username,
          jabatan: jabatan.isEmpty ? null : jabatan,
        ),
      );
      AppDialogs.success('Profil berhasil diperbarui.');
      Get.back();
    } on ApiException catch (e) {
      AppDialogs.error(e.message);
    } catch (_) {
      AppDialogs.error('Gagal memperbarui profil.');
    } finally {
      isSaving.value = false;
    }
  }
}
