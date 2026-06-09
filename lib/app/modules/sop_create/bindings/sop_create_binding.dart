import 'package:get/get.dart';

import '../../../data/repositories/sop_repository.dart';
import '../controllers/sop_create_controller.dart';

class SopCreateBinding extends Bindings {
  @override
  void dependencies() {
    // The flow can be opened directly; make sure its repository exists.
    if (!Get.isRegistered<SopRepository>()) {
      Get.put<SopRepository>(SopRepository(), permanent: true);
    }
    Get.lazyPut<SopCreateController>(() => SopCreateController());
  }
}
