import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/utils/relative_time.dart';
import '../../../data/models/sop_model.dart';
import '../../../data/repositories/sop_repository.dart';

class RiwayatController extends GetxController {
  final SopRepository _sopRepo = Get.find<SopRepository>();

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString query = ''.obs;
  final RxList<SopModel> _all = <SopModel>[].obs;

  List<SopModel> get _filtered {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return _all;
    return _all
        .where((s) =>
            s.sopName.toLowerCase().contains(q) ||
            s.kategori.toLowerCase().contains(q))
        .toList();
  }

  /// SOPs grouped by relative-day bucket, preserving newest-first order.
  Map<String, List<SopModel>> get grouped {
    final map = <String, List<SopModel>>{};
    for (final s in _filtered) {
      map.putIfAbsent(dayBucket(s.createdAt), () => <SopModel>[]).add(s);
    }
    return map;
  }

  bool get isEmpty => _filtered.isEmpty;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      final page = await _sopRepo.list(page: 1, limit: 50);
      final items = page.items.toList()
        ..sort((a, b) => (b.createdAt ?? DateTime(0))
            .compareTo(a.createdAt ?? DateTime(0)));
      _all.assignAll(items);
    } on ApiException catch (e) {
      error.value = e.message;
    } catch (_) {
      error.value = 'Gagal memuat riwayat. Tarik untuk menyegarkan.';
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String value) => query.value = value;
}
