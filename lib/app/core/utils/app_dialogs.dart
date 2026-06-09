import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Centralised user feedback (success / error snackbars).
class AppDialogs {
  AppDialogs._();

  static void success(String message, {String title = 'Berhasil'}) {
    _snack(title, message, AppColors.success, Icons.check_circle_rounded);
  }

  static void error(String message, {String title = 'Gagal'}) {
    _snack(title, message, AppColors.danger, Icons.error_outline_rounded);
  }

  static void info(String message, {String title = 'Info'}) {
    _snack(title, message, AppColors.primary, Icons.info_outline_rounded);
  }

  static void _snack(
    String title,
    String message,
    Color color,
    IconData icon,
  ) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: color,
      colorText: AppColors.white,
      icon: Icon(icon, color: AppColors.white, size: 24.sp),
      shouldIconPulse: false,
      margin: EdgeInsets.all(AppSpacing.lg.w),
      borderRadius: AppSpacing.radiusMd.r,
      duration: const Duration(seconds: 3),
      titleText: Text(
        title,
        style: AppTextStyles.p2Medium.copyWith(color: AppColors.white),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.c1Regular.copyWith(color: AppColors.white),
      ),
    );
  }
}
