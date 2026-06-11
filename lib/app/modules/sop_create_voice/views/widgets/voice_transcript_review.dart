import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../widgets/app_input_decoration.dart';
import '../../../sop_create/views/widgets/sop_create_widgets.dart';
import '../../controllers/sop_create_voice_controller.dart';

/// Stage 2 — shows the transcript (editable) and lets the user generate or
/// re-record.
class VoiceTranscriptReview extends StatelessWidget {
  final SopCreateVoiceController controller;

  const VoiceTranscriptReview({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.xxxl.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SuccessBanner(),
                SizedBox(height: AppSpacing.lg.h),
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.schedule_rounded,
                          label: 'Durasi',
                          value: controller.durationFormatted.value.isEmpty
                              ? '-'
                              : controller.durationFormatted.value,
                        ),
                      ),
                      SizedBox(width: AppSpacing.md.w),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.text_fields_rounded,
                          label: 'Kata',
                          value: '${controller.wordCount.value}',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.lg.h),
                Text(
                  'Hasil transkripsi (bisa diedit)',
                  style: AppTextStyles.fieldLabel,
                ),
                SizedBox(height: AppSpacing.sm.h),
                TextField(
                  controller: controller.transcriptController,
                  maxLength: 1500,
                  maxLines: 10,
                  minLines: 6,
                  style: AppTextStyles.input,
                  decoration: appInputDecoration(
                    hint: 'Hasil transkripsi audio Anda...',
                  ),
                ),
                SizedBox(height: AppSpacing.md.h),
                Text(
                  'Periksa dan perbaiki teks bila ada kata yang kurang tepat '
                  'sebelum membuat SOP.',
                  style: AppTextStyles.c1Regular,
                ),
              ],
            ),
          ),
        ),
        SopBottomBar(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconPrimaryButton(
                label: 'Generate SOP Sekarang',
                icon: Icons.auto_awesome_rounded,
                color: AppColors.primaryDeep,
                onPressed: controller.generate,
              ),
              SizedBox(height: AppSpacing.sm.h),
              TextButton.icon(
                onPressed: controller.rekamUlang,
                icon: Icon(Icons.refresh_rounded,
                    size: 18.sp, color: AppColors.textSecondary),
                label: Text(
                  'Rekam Ulang',
                  style: AppTextStyles.p2Medium
                      .copyWith(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
        border: Border.all(color: AppColors.success.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded,
              color: AppColors.success, size: 24.sp),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Text(
              'Audio berhasil ditranskripsi!',
              style:
                  AppTextStyles.p2Medium.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20.sp),
          SizedBox(height: AppSpacing.xs.h),
          Text(value, style: AppTextStyles.h4Bold),
          SizedBox(height: 2.h),
          Text(label, style: AppTextStyles.c2Regular),
        ],
      ),
    );
  }
}
