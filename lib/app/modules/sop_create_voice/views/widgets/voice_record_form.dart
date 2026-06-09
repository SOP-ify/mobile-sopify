import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../widgets/app_text_field.dart';
import '../../../sop_create/views/widgets/sop_create_widgets.dart';
import '../../controllers/sop_create_voice_controller.dart';
import 'recording_wave.dart';

/// Stage 1 — name + business field + the record button that captures audio
/// and transcribes it.
class VoiceRecordForm extends StatelessWidget {
  final SopCreateVoiceController controller;

  const VoiceRecordForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          Text('Bidang usaha', style: AppTextStyles.fieldLabel),
          SizedBox(height: AppSpacing.md.h),
          Obx(
            () => SopCategoryChips(
              categories: controller.categories,
              selected: controller.selectedKategori.value,
              onSelect: controller.selectKategori,
              horizontal: true,
            ),
          ),
          SizedBox(height: AppSpacing.xl.h),
          Text('Rekam prosedur kerja Anda', style: AppTextStyles.fieldLabel),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            'Ceritakan langkah kerja seperti menjelaskan ke karyawan baru. '
            'AI akan menyusunnya menjadi SOP terstruktur.',
            style: AppTextStyles.c1Regular,
          ),
          SizedBox(height: AppSpacing.lg.h),
          _RecordCard(controller: controller),
          SizedBox(height: AppSpacing.xl.h),
          const _TipsRow(),
        ],
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final SopCreateVoiceController controller;

  const _RecordCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.recState.value;
      final isRecording = state == VoiceRecState.recording;
      final isTranscribing = state == VoiceRecState.transcribing;

      return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.xxxl.h,
        horizontal: AppSpacing.lg.w,
      ),
      decoration: BoxDecoration(
        color: isRecording ? AppColors.dangerBg : AppColors.paleBlueFill,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
        border: Border.all(
          color: isRecording ? AppColors.danger : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          if (isTranscribing) ...[
            SizedBox(
              width: 44.r,
              height: 44.r,
              child: const CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              'Mentranskripsi audio...',
              style: AppTextStyles.p2Medium.copyWith(color: AppColors.primary),
            ),
            SizedBox(height: AppSpacing.xs.h),
            Text(
              'Mengubah suara Anda menjadi teks',
              style: AppTextStyles.c1Regular,
            ),
          ] else ...[
            _MicButton(
              isRecording: isRecording,
              onTap: controller.toggleRecord,
            ),
            SizedBox(height: AppSpacing.lg.h),
            if (isRecording) ...[
              const RecordingWave(),
              SizedBox(height: AppSpacing.md.h),
              Text(
                '${controller.elapsedFormatted} / ${controller.maxFormatted}',
                style: AppTextStyles.h4Bold.copyWith(color: AppColors.danger),
              ),
              SizedBox(height: AppSpacing.xs.h),
              Text(
                'Sedang merekam... ketuk untuk berhenti',
                style: AppTextStyles.c1Regular,
              ),
            ] else ...[
              Text(
                'Ketuk untuk mulai merekam',
                style:
                    AppTextStyles.p2Medium.copyWith(color: AppColors.primary),
              ),
              SizedBox(height: AppSpacing.xs.h),
              Text(
                'Maksimal ${controller.maxFormatted} menit',
                style: AppTextStyles.c1Regular,
              ),
            ],
          ],
        ],
      ),
      );
    });
  }
}

class _MicButton extends StatelessWidget {
  final bool isRecording;
  final VoidCallback onTap;

  const _MicButton({required this.isRecording, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = isRecording ? AppColors.danger : AppColors.primary;
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 80.r,
          height: 80.r,
          alignment: Alignment.center,
          child: Icon(
            isRecording ? Icons.stop_rounded : Icons.mic_rounded,
            color: AppColors.white,
            size: 38.sp,
          ),
        ),
      ),
    );
  }
}

class _TipsRow extends StatelessWidget {
  const _TipsRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        color: AppColors.paleBlueFill,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _TipLine('Bicara dengan jelas dan tidak terburu-buru'),
          _TipLine('Sebutkan langkah secara berurutan'),
          _TipLine('Rekam di tempat yang tidak berisik'),
        ],
      ),
    );
  }
}

class _TipLine extends StatelessWidget {
  final String text;

  const _TipLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded,
              size: 15.sp, color: AppColors.primary),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.c1Regular.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
