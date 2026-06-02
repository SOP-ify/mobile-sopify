import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  /// Brand name font (used for the "sop-ify" wordmark when rendered as text).
  static TextStyle brand({double? fontSize, Color? color}) => GoogleFonts.fredoka(
        fontSize: (fontSize ?? 32).sp,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.navyDeep,
      );

  // H1 — App bar, page title (18-20pt)
  static TextStyle h1({Color? color}) => GoogleFonts.nunito(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.darkCharcoal,
      );

  // H2 — Section heading (15-16pt)
  static TextStyle h2({Color? color}) => GoogleFonts.nunito(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.darkCharcoal,
      );

  // Body (13-14pt)
  static TextStyle body({Color? color}) => GoogleFonts.nunito(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.charcoal,
      );

  // Label & form labels — Nunito SemiBold 14pt
  static TextStyle label({Color? color}) => GoogleFonts.nunito(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.charcoal,
      );

  // Input text — Nunito Regular 14pt
  static TextStyle input({Color? color}) => GoogleFonts.nunito(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.darkCharcoal,
      );

  // Placeholder / hint — Nunito Regular italic, #9CA3AF
  static TextStyle hint({Color? color}) => GoogleFonts.nunito(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.lightGrayText,
      );

  // Button — Nunito Bold 16pt
  static TextStyle button({Color? color}) => GoogleFonts.nunito(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.white,
      );

  // Caption — Badge, timestamp, metadata (11-12pt)
  static TextStyle caption({Color? color}) => GoogleFonts.nunito(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.gray,
      );

  // Link text
  static TextStyle link({Color? color}) => GoogleFonts.nunito(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.deepBlue,
      );
}
