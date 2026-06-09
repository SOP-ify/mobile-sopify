import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Stage 2 — shown while the ML endpoint generates the SOP.
class SopProcessing extends StatelessWidget {
  const SopProcessing({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.xxxl.w),
      child: Column(
        children: [
          SizedBox(height: AppSpacing.huge.h),
          Container(
            width: 84.r,
            height: 84.r,
            decoration: BoxDecoration(
              color: AppColors.paleBlueFill,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primary,
              size: 38.sp,
            ),
          ),
          SizedBox(height: AppSpacing.xl.h),
          Text(
            'AI sedang menganalisis teks Anda',
            textAlign: TextAlign.center,
            style: AppTextStyles.h4Bold,
          ),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            'Mendeteksi langkah, peran, dan estimasi waktu...',
            textAlign: TextAlign.center,
            style: AppTextStyles.c1Regular,
          ),
          SizedBox(height: AppSpacing.xl.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm.r),
            child: LinearProgressIndicator(
              minHeight: 8.h,
              backgroundColor: AppColors.border,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primaryDeep),
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            'Mohon tunggu sebentar...',
            textAlign: TextAlign.center,
            style: AppTextStyles.c1Regular.copyWith(color: AppColors.hint),
          ),
          SizedBox(height: AppSpacing.xl.h),
          Container(
            padding: EdgeInsets.all(AppSpacing.lg.r),
            decoration: BoxDecoration(
              color: AppColors.paleBlueFill,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),
                Text(
                  'Menyusun struktur SOP...',
                  style: AppTextStyles.c1Medium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
