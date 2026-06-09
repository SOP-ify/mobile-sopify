import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_bottom_nav_bar.dart';
import '../../home/views/home_view.dart';
import '../../profil/views/profil_view.dart';
import '../../riwayat/views/riwayat_view.dart';
import '../controllers/botnavbar_controller.dart';

/// Main app shell: hosts the tab pages in an [IndexedStack] (so each tab keeps
/// its state) and renders the shared bottom navigation bar.
class BotNavBarView extends GetView<BotNavBarController> {
  const BotNavBarView({super.key});

  @override
  Widget build(BuildContext context) {
    const pages = [
      HomeView(),
      RiwayatView(),
      ProfilView(),
    ];

    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
        ),
      ),
    );
  }
}
