import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/primary_button.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.welcomeFill,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text('Edit Profil', style: AppTextStyles.h3Bold),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg.w,
            AppSpacing.xl.h,
            AppSpacing.lg.w,
            AppSpacing.xxl.h,
          ),
          child: Column(
            children: [
              _Avatar(name: controller.fullName),
              SizedBox(height: AppSpacing.xl.h),
              Container(
                padding: EdgeInsets.all(AppSpacing.lg.r),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _EditField(
                      label: 'Nama Lengkap',
                      controller: controller.fullNameC,
                      textCapitalization: TextCapitalization.words,
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    _EditField(
                      label: 'Nama Pengguna',
                      controller: controller.usernameC,
                      prefix: '@',
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    _EditField(
                      label: 'Jabatan',
                      controller: controller.jabatanC,
                      textCapitalization: TextCapitalization.words,
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    _ReadOnlyField(
                      label: 'Alamat Email',
                      value: controller.email,
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    _ReadOnlyField(
                      label: 'Nomor Telepon',
                      value: controller.phoneNumber,
                    ),
                    SizedBox(height: AppSpacing.xl.h),
                    Obx(
                      () => PrimaryButton(
                        label: 'Simpan Perubahan',
                        isLoading: controller.isSaving.value,
                        onPressed: controller.save,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  if (parts.isEmpty) return '?';
  return parts.take(2).map((p) => p[0].toUpperCase()).join();
}

class _Avatar extends StatelessWidget {
  final String name;
  const _Avatar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96.r,
      height: 96.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.iconTileBg,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: 3.r),
      ),
      child: Text(
        _initials(name),
        style: AppTextStyles.brand(size: 32, color: AppColors.primary),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? prefix;
  final TextCapitalization textCapitalization;

  const _EditField({
    required this.label,
    required this.controller,
    this.prefix,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        SizedBox(height: AppSpacing.xs.h),
        Container(
          height: AppSpacing.fieldHeight.h,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
          decoration: BoxDecoration(
            color: AppColors.fieldFill,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
            border: Border.all(color: AppColors.border),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              if (prefix != null) ...[
                Text(prefix!, style: AppTextStyles.input),
              ],
              Expanded(
                child: TextField(
                  controller: controller,
                  style: AppTextStyles.input,
                  cursorColor: AppColors.primary,
                  textCapitalization: textCapitalization,
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        SizedBox(height: AppSpacing.xs.h),
        Container(
          height: AppSpacing.fieldHeight.h,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
          decoration: BoxDecoration(
            color: AppColors.welcomeFill,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
            border: Border.all(color: AppColors.border),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: AppTextStyles.input.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.lock_outline_rounded,
                size: 16.sp,
                color: AppColors.iconMuted,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
