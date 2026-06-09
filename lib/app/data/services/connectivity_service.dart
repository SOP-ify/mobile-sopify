import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../../core/utils/app_dialogs.dart';

/// Tracks network reachability and notifies the user when connectivity drops
/// or is restored. Registered once in `main.dart`; resolve with
/// `ConnectivityService.to` and read [isOnline] reactively where needed.
class ConnectivityService extends GetxService {
  static ConnectivityService get to => Get.find<ConnectivityService>();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _sub;

  final RxBool isOnline = true.obs;

  Future<ConnectivityService> init() async {
    isOnline.value = _isConnected(await _connectivity.checkConnectivity());
    _sub = _connectivity.onConnectivityChanged.listen(_update);
    return this;
  }

  void _update(List<ConnectivityResult> results) {
    final online = _isConnected(results);
    if (online == isOnline.value) return;
    isOnline.value = online;
    if (online) {
      AppDialogs.success('Koneksi internet kembali tersambung.');
    } else {
      AppDialogs.error('Tidak ada koneksi internet.', title: 'Offline');
    }
  }

  bool _isConnected(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
