import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../data/models/sop_model.dart';
import '../../../data/repositories/sop_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/services/auth_service.dart';

class HomeController extends GetxController {
  final UserRepository _userRepo = Get.find<UserRepository>();
  final SopRepository _sopRepo = Get.find<SopRepository>();
  final AuthService _auth = AuthService.to;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxInt totalSop = 0.obs;
  final RxList<SopModel> recentSops = <SopModel>[].obs;

  String get userName => _auth.currentUser.value?.fullName ?? 'Pengguna';

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      final summary = await _userRepo.getSummary();
      totalSop.value = summary.totalSop;
      final page = await _sopRepo.list(page: 1, limit: 5);
      recentSops.assignAll(page.items.take(3).toList());
    } on ApiException catch (e) {
      error.value = e.message;
    } catch (_) {
      error.value = 'Gagal memuat data. Tarik untuk menyegarkan.';
    } finally {
      isLoading.value = false;
    }
  }
}
