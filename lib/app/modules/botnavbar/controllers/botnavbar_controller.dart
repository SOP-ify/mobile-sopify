import 'package:get/get.dart';

/// Owns the selected tab index for the main app shell.
class BotNavBarController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changePage(int index) => currentIndex.value = index;
}
