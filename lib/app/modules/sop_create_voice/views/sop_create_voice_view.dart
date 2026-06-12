import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../sop_create/views/widgets/sop_processing.dart';
import '../../sop_create/views/widgets/sop_result.dart';
import '../../sop_create/views/widgets/sop_step_indicator.dart';
import '../controllers/sop_create_voice_controller.dart';
import '../../../routes/app_pages.dart';
import '../../botnavbar/controllers/botnavbar_controller.dart';
import 'widgets/voice_record_form.dart';
import 'widgets/voice_transcript_review.dart';

class SopCreateVoiceView extends GetView<SopCreateVoiceController> {
  const SopCreateVoiceView({super.key});

  static const List<String> _labels = ['Rekam Suara', 'Transkripsi', 'Generate'];

  void _goToHome() {
    if (Get.isRegistered<BotNavBarController>()) {
      Get.find<BotNavBarController>().changePage(0);
    }
    Get.until((route) => route.settings.name == Routes.MAIN);
  }

  String _titleFor(int step, bool generating) {
    switch (step) {
      case 2:
        return 'Periksa Transkripsi';
      case 3:
        return generating ? 'Membuat SOP...' : 'Hasil SOP';
      default:
        return 'Buat SOP dari Suara';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final step = controller.step.value;
      final generating = controller.isGenerating.value;
      final recState = controller.recState.value;
      final busy = recState == VoiceRecState.recording ||
          recState == VoiceRecState.transcribing ||
          generating;
      return PopScope(
        canPop: !busy,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            leading: !busy
                ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: _goToHome,
            )
                : null,
            title: Text(
              _titleFor(step, generating),
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
                child: SopStepIndicator(currentStep: step, labels: _labels),
              ),
              Divider(height: 1.h, color: AppColors.divider),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _bodyFor(step, generating),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _bodyFor(int step, bool generating) {
    switch (step) {
      case 2:
        return VoiceTranscriptReview(
          key: const ValueKey('review'),
          controller: controller,
        );
      case 3:
        return generating
            ? const SopProcessing(key: ValueKey('processing'))
            : SopResult(key: const ValueKey('result'), controller: controller);
      default:
        return VoiceRecordForm(
          key: const ValueKey('record'),
          controller: controller,
        );
    }
  }
}
