import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'sop_share.dart';

/// Success popup shown after a SOP is saved to history, offering to share the
/// result to WhatsApp or another app. Resolves when the user taps "Selesai".
Future<void> showSopSavedDialog({required String shareText}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxxl.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                color: AppColors.successBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 38.sp,
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              'Tersimpan ke Riwayat',
              textAlign: TextAlign.center,
              style: AppTextStyles.h4Bold,
            ),
            SizedBox(height: AppSpacing.xs.h),
            Text(
              'SOP Anda berhasil disimpan. Bagikan ke tim Anda sekarang?',
              textAlign: TextAlign.center,
              style: AppTextStyles.c1Regular,
            ),
            SizedBox(height: AppSpacing.xl.h),
            _FilledAction(
              label: 'Bagikan ke WhatsApp',
              icon: Icons.chat_rounded,
              color: const Color(0xFF25D366),
              onTap: () => SopShare.whatsapp(shareText),
            ),
            SizedBox(height: AppSpacing.md.h),
            _OutlinedAction(
              label: 'Bagikan ke lainnya',
              icon: Icons.ios_share_rounded,
              onTap: () => SopShare.other(shareText),
            ),
            SizedBox(height: AppSpacing.sm.h),
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Selesai',
                style: AppTextStyles.p2Medium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _FilledAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FilledAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSpacing.radiusMd.r);
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight.h,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, borderRadius: radius),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: radius,
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.white, size: 20.sp),
                SizedBox(width: AppSpacing.sm.w),
                Text(label, style: AppTextStyles.button),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlinedAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _OutlinedAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSpacing.radiusMd.r);
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: AppColors.border),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: radius,
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.primary, size: 20.sp),
                SizedBox(width: AppSpacing.sm.w),
                Text(
                  label,
                  style: AppTextStyles.button.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
