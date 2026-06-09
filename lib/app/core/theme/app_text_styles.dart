import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle _font({
    required double size,
    required FontWeight weight,
    double? lineHeight,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.nunito(
      fontSize: size.sp,
      fontWeight: weight,
      height: lineHeight == null ? null : lineHeight / size,
      color: color,
    );
  }

  /// Brand wordmark font.
  static TextStyle brand({double size = 28, Color? color}) =>
      GoogleFonts.fredoka(
        fontSize: size.sp,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.brandNavy,
      );

  // Headings
  static TextStyle get h1Bold => _font(size: 24, weight: FontWeight.w700);
  static TextStyle get h2Bold => _font(size: 20, weight: FontWeight.w700);
  static TextStyle get h3Bold => _font(size: 18, weight: FontWeight.w700);
  static TextStyle get h4Bold => _font(size: 16, weight: FontWeight.w700);

  // Paragraph
  static TextStyle get p1Medium => _font(size: 16, weight: FontWeight.w500);
  static TextStyle get p1Regular =>
      _font(size: 16, weight: FontWeight.w400, color: AppColors.textBody);
  static TextStyle get p2Regular => _font(
        size: 14,
        weight: FontWeight.w400,
        lineHeight: 22,
        color: AppColors.textBody,
      );
  static TextStyle get p2Medium => _font(size: 14, weight: FontWeight.w600);

  // Captions
  static TextStyle get c1Regular =>
      _font(size: 13, weight: FontWeight.w400, color: AppColors.textSecondary);
  static TextStyle get c1Medium => _font(size: 13, weight: FontWeight.w600);
  static TextStyle get c2Regular =>
      _font(size: 12, weight: FontWeight.w400, color: AppColors.textSecondary);
  static TextStyle get c2Medium =>
      _font(size: 12, weight: FontWeight.w600, color: AppColors.textSecondary);

  // Button label
  static TextStyle get button => _font(
        size: 16,
        weight: FontWeight.w700,
        color: AppColors.white,
      );

  // Field label
  static TextStyle get fieldLabel =>
      _font(size: 14, weight: FontWeight.w600, color: AppColors.label);

  // Input + hint
  static TextStyle get input =>
      _font(size: 14, weight: FontWeight.w400, color: AppColors.textPrimary);
  static TextStyle get hint =>
      _font(size: 14, weight: FontWeight.w400, color: AppColors.hint);
}
