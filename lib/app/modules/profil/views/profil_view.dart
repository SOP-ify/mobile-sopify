import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/user_model.dart';
import '../../../widgets/primary_button.dart';
import '../controllers/profil_controller.dart';

class ProfilView extends GetView<ProfilController> {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _Header(onEdit: () => _openEditSheet(context)),
          Expanded(
            child: Obx(() {
              final user = controller.user.value;
              if (controller.isLoading.value && user == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (user == null) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl.r),
                    child: Text(
                      controller.error.value.isEmpty
                          ? 'Profil tidak tersedia.'
                          : controller.error.value,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.c1Regular,
                    ),
                  ),
                );
              }
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: controller.load,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg.w,
                    AppSpacing.lg.h,
                    AppSpacing.lg.w,
                    AppSpacing.xxl.h,
                  ),
                  children: [
                    _ProfileCard(user: user),
                    SizedBox(height: AppSpacing.lg.h),
                    _ContactCard(user: user),
                    SizedBox(height: AppSpacing.lg.h),
                    _SummaryCard(total: controller.totalSop.value),
                    SizedBox(height: AppSpacing.lg.h),
                    _LogoutCard(
                      isLoading: controller.isLoggingOut.value,
                      onTap: controller.logout,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _openEditSheet(BuildContext context) {
    final user = controller.user.value;
    if (user == null) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl.r),
        ),
      ),
      builder: (_) => _EditProfileSheet(controller: controller, user: user),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onEdit;
  const _Header({required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg.w,
            vertical: AppSpacing.md.h,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Profil',
                  style: AppTextStyles.h3Bold.copyWith(color: AppColors.white),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onEdit,
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined,
                        color: AppColors.white, size: 18.sp),
                    SizedBox(width: AppSpacing.xs.w),
                    Text(
                      'Edit',
                      style: AppTextStyles.c1Medium
                          .copyWith(color: AppColors.white),
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
  final letters = parts.take(2).map((p) => p[0].toUpperCase()).join();
  return letters;
}

class _ProfileCard extends StatelessWidget {
  final UserModel user;
  const _ProfileCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final jabatan = user.jabatan;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.xl.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 72.r,
            height: 72.r,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.iconTileBg,
              shape: BoxShape.circle,
            ),
            child: Text(
              _initials(user.fullName),
              style: AppTextStyles.brand(size: 26, color: AppColors.primary),
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            user.fullName.isEmpty ? '-' : user.fullName,
            style: AppTextStyles.h3Bold,
            textAlign: TextAlign.center,
          ),
          if (jabatan != null && jabatan.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm.h),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md.w,
                vertical: AppSpacing.xs.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.paleBlueFill,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl.r),
              ),
              child: Text(
                jabatan,
                style:
                    AppTextStyles.c1Medium.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final UserModel user;
  const _ContactCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _ContactRow(
            icon: Icons.mail_outline_rounded,
            label: 'Email',
            value: user.email.isEmpty ? '-' : user.email,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
            child: const Divider(height: 1, color: AppColors.divider),
          ),
          _ContactRow(
            icon: Icons.phone_outlined,
            label: 'Telepon',
            value: (user.phoneNumber == null || user.phoneNumber!.isEmpty)
                ? '-'
                : user.phoneNumber!,
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.iconTile.r,
          height: AppSpacing.iconTile.r,
          decoration: BoxDecoration(
            color: AppColors.iconTileBg,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18.sp),
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.c2Regular),
              SizedBox(height: 2.h),
              Text(
                value,
                style: AppTextStyles.p2Medium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int total;
  const _SummaryCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        color: AppColors.welcomeFill,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
      ),
      child: Row(
        children: [
          Icon(Icons.insights_rounded, color: AppColors.primary, size: 24.sp),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Text(
              'Total SOP Dibuat',
              style: AppTextStyles.p2Medium,
            ),
          ),
          Text(
            '$total',
            style: AppTextStyles.brand(size: 24, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _LogoutCard extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  const _LogoutCard({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSpacing.radiusLg.r);
    return Material(
      color: AppColors.white,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: isLoading ? null : onTap,
        child: Container(
          padding: EdgeInsets.all(AppSpacing.lg.r),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: AppSpacing.iconTile.r,
                height: AppSpacing.iconTile.r,
                decoration: BoxDecoration(
                  color: AppColors.dangerBg,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
                ),
                child: Icon(Icons.logout_rounded,
                    color: AppColors.danger, size: 18.sp),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keluar',
                      style: AppTextStyles.p2Medium
                          .copyWith(color: AppColors.danger),
                    ),
                    SizedBox(height: 2.h),
                    Text('Akhiri sesi Anda', style: AppTextStyles.c1Regular),
                  ],
                ),
              ),
              if (isLoading)
                SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.danger),
                  ),
                )
              else
                Icon(Icons.chevron_right_rounded,
                    color: AppColors.iconMuted, size: 20.sp),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  final ProfilController controller;
  final UserModel user;
  const _EditProfileSheet({required this.controller, required this.user});

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _name =
      TextEditingController(text: widget.user.fullName);
  late final TextEditingController _jabatan =
      TextEditingController(text: widget.user.jabatan ?? '');

  @override
  void dispose() {
    _name.dispose();
    _jabatan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg.w,
        right: AppSpacing.lg.w,
        top: AppSpacing.xl.h,
        bottom: AppSpacing.xl.h + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Edit Profil', style: AppTextStyles.h3Bold),
          SizedBox(height: AppSpacing.lg.h),
          _Field(label: 'Nama Lengkap', controller: _name),
          SizedBox(height: AppSpacing.md.h),
          _Field(label: 'Jabatan', controller: _jabatan),
          SizedBox(height: AppSpacing.xl.h),
          Obx(
            () => PrimaryButton(
              label: 'Simpan',
              isLoading: widget.controller.isSaving.value,
              onPressed: _save,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final ok = await widget.controller.saveProfile(
      fullName: _name.text,
      jabatan: _jabatan.text,
    );
    if (ok && mounted) Navigator.of(context).pop();
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const _Field({required this.label, required this.controller});

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
          child: TextField(
            controller: controller,
            style: AppTextStyles.input,
            cursorColor: AppColors.primary,
            decoration: const InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
