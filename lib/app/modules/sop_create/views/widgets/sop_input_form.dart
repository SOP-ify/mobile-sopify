import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../widgets/app_text_field.dart';
import '../../controllers/sop_create_controller.dart';
import 'sop_create_widgets.dart';

/// Stage 1 — the user types the SOP name, the procedure text, and picks a
/// business field, then taps "Generate SOP Sekarang".
class SopInputForm extends StatelessWidget {
  final SopCreateController controller;

  const SopInputForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.xxxl.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  label: 'Nama SOP',
                  hint: 'Contoh: SOP Pelayanan Kasir',
                  controller: controller.sopNameController,
                ),
                SizedBox(height: AppSpacing.xl.h),
                Text(
                  'Tulis prosedur kerja Anda',
                  style: AppTextStyles.fieldLabel,
                ),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  'Ceritakan dengan bahasa sehari-hari. AI akan menyusunnya '
                  'menjadi SOP terstruktur.',
                  style: AppTextStyles.c1Regular,
                ),
                SizedBox(height: AppSpacing.sm.h),
                Obx(
                  () => SopNoteField(
                    controller: controller.catatanController,
                    maxLength: SopCreateController.maxCatatan,
                    currentLength: controller.charCount.value,
                    label: '',
                    hint: 'Contoh: Pertama kasir menyambut pelanggan, lalu '
                        'catat pesanan di buku, konfirmasi harga, terima '
                        'pembayaran tunai atau transfer, cetak struk, dan '
                        'ucapkan terima kasih.',
                  ),
                ),
                SizedBox(height: AppSpacing.lg.h),
                Text('Bidang usaha', style: AppTextStyles.fieldLabel),
                SizedBox(height: AppSpacing.md.h),
                Obx(
                  () => SopCategoryChips(
                    categories: controller.categories,
                    selected: controller.selectedKategori.value,
                    onSelect: controller.selectKategori,
                  ),
                ),
                SizedBox(height: AppSpacing.xl.h),
                const _InfoBanner(),
              ],
            ),
          ),
        ),
        SopBottomBar(
          child: IconPrimaryButton(
            label: 'Generate SOP Sekarang',
            icon: Icons.auto_awesome_rounded,
            color: AppColors.primaryDeep,
            onPressed: controller.generate,
          ),
        ),
      ],
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        color: AppColors.paleBlueFill,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Icon(
              Icons.circle,
              size: 8.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Text(
              'AI siap memproses. SOP akan dibuat dalam 5-30 detik lengkap '
              'dengan langkah, penanggung jawab, dan estimasi waktu.',
              style: AppTextStyles.c1Regular.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
