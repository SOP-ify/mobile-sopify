import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/sop_create_controller.dart';
import 'widgets/sop_input_form.dart';
import 'widgets/sop_processing.dart';
import 'widgets/sop_result.dart';
import 'widgets/sop_step_indicator.dart';
import '../../../routes/app_pages.dart';
import '../../botnavbar/controllers/botnavbar_controller.dart';

class SopCreateView extends GetView<SopCreateController> {
  const SopCreateView({super.key});

  void _goToHome() {
    if (Get.isRegistered<BotNavBarController>()) {
      Get.find<BotNavBarController>().changePage(0);
    }
    Get.until((route) => route.settings.name == Routes.MAIN);
  }

  String _titleFor(int step) {
    switch (step) {
      case 2:
        return 'Membuat SOP...';
      case 3:
        return 'Hasil SOP';
      default:
        return 'Buat SOP dari Teks';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final step = controller.step.value;
      // Block accidental exit while the AI is working.
      return PopScope(
        canPop: step != 2,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            leading: step != 2
                ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: _goToHome,
            )
                : null,
            title: Text(
              _titleFor(step),
              style: AppTextStyles.h4Bold.copyWith(color: AppColors.white),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xxxl.w,
                  AppSpacing.lg.h,
                  AppSpacing.xxxl.w,
                  AppSpacing.lg.h,
                ),
                child: SopStepIndicator(currentStep: step),
              ),
              Divider(height: 1.h, color: AppColors.divider),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _bodyFor(step),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _bodyFor(int step) {
    switch (step) {
      case 2:
        return const SopProcessing(key: ValueKey('processing'));
      case 3:
        return SopResult(key: const ValueKey('result'), controller: controller);
      default:
        return SopInputForm(
          key: const ValueKey('input'),
          controller: controller,
        );
    }
  }
}
