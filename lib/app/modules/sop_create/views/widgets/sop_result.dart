import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/sop_categories.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/generated_sop.dart';
import '../../../../data/models/sop_step.dart';
import '../../controllers/sop_result_source.dart';
import 'sop_create_widgets.dart';

/// Stage 3 — shows the generated SOP and lets the user persist it.
class SopResult extends StatelessWidget {
  final SopResultSource controller;

  const SopResult({super.key, required this.controller});

  String _kategoriLabel(String value) {
    return kSopCategories
        .firstWhere(
          (c) => c.value == value,
          orElse: () => SopCategory(value, value),
        )
        .label;
  }

  @override
  Widget build(BuildContext context) {
    final GeneratedSop? sop = controller.result.value;
    if (sop == null) {
      return const SizedBox.shrink();
    }
    final kategori = _kategoriLabel(controller.selectedKategori.value);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.xxxl.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SuccessBanner(stepCount: sop.stepCount),
                SizedBox(height: AppSpacing.lg.h),
                _SopHeaderCard(
                  title: controller.sopName,
                  subtitle: '$kategori · Dibuat AI',
                ),
                SizedBox(height: AppSpacing.lg.h),
                for (int i = 0; i < sop.steps.length; i++) ...[
                  _StepTile(step: sop.steps[i]),
                  if (i < sop.steps.length - 1)
                    Divider(height: 1.h, color: AppColors.divider),
                ],
              ],
            ),
          ),
        ),
        SopBottomBar(
          child: Obx(
            () => IconPrimaryButton(
              label: 'Simpan ke Daftar SOP',
              icon: Icons.save_outlined,
              color: AppColors.success,
              isLoading: controller.isSaving.value,
              onPressed: controller.save,
            ),
          ),
        ),
      ],
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  final int stepCount;

  const _SuccessBanner({required this.stepCount});

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SOP berhasil dibuat!',
                  style: AppTextStyles.p2Medium
                      .copyWith(color: AppColors.textPrimary),
                ),
                SizedBox(height: 2.h),
                Text(
                  '$stepCount langkah terstruktur dari teks Anda',
                  style: AppTextStyles.c1Regular,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SopHeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SopHeaderCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.isEmpty ? 'SOP' : title,
            style: AppTextStyles.h4Bold.copyWith(color: AppColors.white),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            subtitle,
            style: AppTextStyles.c1Regular
                .copyWith(color: AppColors.white.withOpacity(0.85)),
          ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final SopStep step;

  const _StepTile({required this.step});

  @override
  Widget build(BuildContext context) {
    final hasMeta = (step.pic != null && step.pic!.isNotEmpty) ||
        (step.durasi != null && step.durasi!.isNotEmpty);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28.r,
            height: 28.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.paleBlueFill,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${step.no}',
              style: AppTextStyles.c1Medium.copyWith(color: AppColors.primary),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.judul, style: AppTextStyles.p2Medium),
                if (step.deskripsi.isNotEmpty &&
                    step.deskripsi != step.judul) ...[
                  SizedBox(height: AppSpacing.xs.h),
                  Text(step.deskripsi, style: AppTextStyles.c1Regular),
                ],
                if (hasMeta) ...[
                  SizedBox(height: AppSpacing.sm.h),
                  _MetaBadge(
                    pic: step.pic,
                    durasi: step.durasi,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  final String? pic;
  final String? durasi;

  const _MetaBadge({this.pic, this.durasi});

  @override
  Widget build(BuildContext context) {
    final parts = <String>[
      if (pic != null && pic!.isNotEmpty) pic!,
      if (durasi != null && durasi!.isNotEmpty) durasi!,
    ];
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_outline_rounded,
              size: 13.sp, color: AppColors.success),
          SizedBox(width: AppSpacing.xs.w),
          Text(
            parts.join(' · '),
            style: AppTextStyles.c2Medium.copyWith(color: AppColors.success),
          ),
        ],
      ),
    );
  }
}
