import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Pale-blue greeting banner shown at the top of the auth screens.
class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: AppColors.welcomeFill,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat Datang di SOP-ify',
            style: AppTextStyles.p2Medium.copyWith(color: AppColors.textPrimary),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            'Temukan kemudahan dalam mengelola operasional bisnis bersama kami.',
            style: AppTextStyles.c1Regular.copyWith(color: AppColors.textBody),
          ),
        ],
      ),
    );
  }
}
