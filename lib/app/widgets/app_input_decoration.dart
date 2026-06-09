import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Shared input decoration so every field looks identical.
InputDecoration appInputDecoration({
  String? hint,
  Widget? prefixIcon,
  Widget? suffixIcon,
  Color? fillColor,
}) {
  OutlineInputBorder borderOf(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
        borderSide: BorderSide(color: color, width: 1),
      );

  return InputDecoration(
    isDense: true,
    filled: true,
    fillColor: fillColor ?? AppColors.fieldFill,
    hintText: hint,
    hintStyle: AppTextStyles.hint,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    contentPadding: EdgeInsets.symmetric(
      horizontal: AppSpacing.lg.w,
      vertical: AppSpacing.lg.h,
    ),
    enabledBorder: borderOf(AppColors.border),
    focusedBorder: borderOf(AppColors.primary),
    border: borderOf(AppColors.border),
  );
}
