import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Blues ---
  static const Color primaryBlue = Color(0xFF1A6FD4); // App bar, splash, accents
  static const Color deepBlue = Color(0xFF005DA8); // Logo, Masuk/Daftar buttons
  static const Color brandBlue = Color(0xFF0057AD); // History app bar, active filter
  static const Color mediumBlue = Color(0xFF0060AE); // SOP card header
  static const Color darkBlue = Color(0xFF0D4B9B); // Stepper accent, secondary border
  static const Color navyDeep = Color(0xFF0B1C30); // Gallery & profile titles
  static const Color darkCharcoal = Color(0xFF1A1A2E); // Main headings

  // --- Neutrals / text ---
  static const Color charcoal = Color(0xFF414753); // Body text
  static const Color slate = Color(0xFF545F73); // Secondary text (gallery/profile)
  static const Color darkGray = Color(0xFF585F6C); // Secondary text (SOP result)
  static const Color coolGray = Color(0xFF64748B); // Muted label step 2
  static const Color gray = Color(0xFF6B7280); // General secondary text, form labels
  static const Color mediumGray = Color(0xFF707785); // Muted text (gallery/profile)
  static const Color grayWarm = Color(0xFF727784); // History metadata
  static const Color lightGrayText = Color(0xFF9CA3AF); // Placeholder, hint, muted

  // --- Borders / dividers ---
  static const Color blueBorderLight = Color(0xFFBFDBFE); // Info box / card border
  static const Color grayBorder = Color(0xFFC0C7D6); // Gallery & profile card border
  static const Color dividerGray = Color(0xFFD1D5DB); // Home dividers
  static const Color borderGray = Color(0xFFE5E7EB); // Input field border, table lines

  // --- Surfaces ---
  static const Color bluePale = Color(0xFFDCE9FF); // Profile/gallery badge bg
  static const Color cardBlueLight = Color(0xFFE5EEFF); // Gallery card bg
  static const Color infoBlueBG = Color(0xFFEBF4FF); // Info box, card bg
  static const Color paleBlueBG = Color(0xFFEFF4FF); // Profile card bg
  static const Color blueTint = Color(0xFFEFF6FF); // Home secondary card
  static const Color greenTint = Color(0xFFF0FDF4); // Badge AKTIF bg
  static const Color offWhiteBlue = Color(0xFFF8F9FF); // Gallery/profile page bg
  static const Color nearWhite = Color(0xFFF9FAFB); // Voice input bg
  static const Color amberTint = Color(0xFFFFFBEB); // Badge DRAFT bg
  static const Color white = Color(0xFFFFFFFF); // Main page bg, text on blue

  // --- Status ---
  static const Color successGreen = Color(0xFF10B981); // Badge AKTIF text, checklist
  static const Color greenPale = Color(0xFFD1FAE5); // Success badge bg
  static const Color greenDark = Color(0xFF065F46); // Success badge text
  static const Color warningAmber = Color(0xFFF59E0B); // Badge DRAFT, highlight
  static const Color amberDark = Color(0xFF92400E); // Warning badge text
  static const Color dangerRed = Color(0xFFBA1A1A); // Error / danger
}
