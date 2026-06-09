import 'package:get/get.dart';

import '../../../data/repositories/user_repository.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<UserRepository>()) {
      Get.put<UserRepository>(UserRepository(), permanent: true);
    }
    Get.lazyPut<EditProfileController>(() => EditProfileController());
  }
}
