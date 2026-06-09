import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'primary_button.dart';

/// "Syarat dan Ketentuan" popup shown from the register screen.
class TermsDialog extends StatelessWidget {
  const TermsDialog({super.key});

  static Future<void> show() => Get.dialog(const TermsDialog());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl.w,
              AppSpacing.xl.h,
              AppSpacing.lg.w,
              AppSpacing.lg.h,
            ),
            child: Row(
              children: [
                Container(
                  width: AppSpacing.iconTile.w,
                  height: AppSpacing.iconTile.w,
                  decoration: BoxDecoration(
                    color: AppColors.iconTileBg,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm.r),
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    color: AppColors.primary,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: Text(
                    'Syarat dan Ketentuan',
                    style: AppTextStyles.h3Bold,
                  ),
                ),
                GestureDetector(
                  onTap: Get.back,
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                    size: 22.sp,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          // Body
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.xl.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _Section(
                    icon: Icons.verified_outlined,
                    title: '1. Penerimaan Ketentuan',
                    body:
                        'Dengan membuat akun atau menggunakan layanan SOP-ify, '
                        'Anda menyatakan telah membaca, memahami, dan menyetujui '
                        'seluruh isi dalam Syarat dan Ketentuan ini. Layanan kami '
                        'disediakan khusus untuk membantu UMKM mengotomatisasi '
                        'Standard Operating Procedure (SOP).',
                  ),
                  SizedBox(height: 20),
                  _Section(
                    icon: Icons.gpp_good_outlined,
                    title: '2. Penggunaan Layanan',
                    body:
                        'Pengguna dilarang menggunakan platform untuk aktivitas '
                        'ilegal, menyebarkan konten berbahaya, atau mencoba '
                        'merusak integritas sistem SOP-ify. Akun bersifat personal '
                        'dan rahasia; pengguna bertanggung jawab penuh atas segala '
                        'aktivitas yang terjadi di bawah identitas akun mereka.',
                  ),
                ],
              ),
            ),
          ),
          // Footer
          Padding(
            padding: EdgeInsets.all(AppSpacing.xl.w),
            child: PrimaryButton(
              label: 'Saya Mengerti',
              color: AppColors.primary,
              onPressed: Get.back,
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _Section({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 18.sp),
            SizedBox(width: AppSpacing.sm.w),
            Text(
              title,
              style: AppTextStyles.p2Medium.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm.h),
        Text(body, style: AppTextStyles.p2Regular),
      ],
    );
  }
}
