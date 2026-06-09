import 'package:get/get.dart';

import '../../../data/models/sop_model.dart';
import '../../../data/repositories/sop_repository.dart';
import '../controllers/sop_detail_controller.dart';

class SopDetailBinding extends Bindings {
  @override
  void dependencies() {
    // The screen can be opened directly; make sure its repository exists.
    if (!Get.isRegistered<SopRepository>()) {
      Get.put<SopRepository>(SopRepository(), permanent: true);
    }
    final args = Get.arguments;
    Get.lazyPut<SopDetailController>(
      () => SopDetailController(args is SopModel ? args : null),
    );
  }
}
