import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/sop_step.dart';
import '../../../widgets/shimmer_box.dart';
import '../controllers/sop_detail_controller.dart';

class SopDetailView extends GetView<SopDetailController> {
  const SopDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const _Header(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const SopListShimmer();
              }
              if (controller.error.value.isNotEmpty) {
                return _ErrorState(
                  message: controller.error.value,
                  onRetry: controller.load,
                );
              }
              final detail = controller.detail.value;
              if (detail == null) {
                return _ErrorState(
                  message: 'SOP tidak ditemukan.',
                  onRetry: controller.load,
                );
              }
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg.w,
                  AppSpacing.lg.h,
                  AppSpacing.lg.w,
                  AppSpacing.xxl.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderCard(
                      title: controller.title,
                      subtitle:
                          '${controller.kategoriLabel} · ${detail.stepCount} langkah',
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    if (detail.steps.isEmpty && detail.sop.isNotEmpty)
                      _PlainSop(text: detail.sop)
                    else
                      for (int i = 0; i < detail.steps.length; i++) ...[
                        _StepTile(step: detail.steps[i]),
                        if (i < detail.steps.length - 1)
                          Divider(height: 1.h, color: AppColors.divider),
                      ],
                  ],
                ),
              );
            }),
          ),
          Obx(() {
            final ready =
                !controller.isLoading.value && controller.detail.value != null;
            if (!ready) return const SizedBox.shrink();
            return _ActionBar(
              onShare: controller.share,
              onCopy: controller.copy,
              onPdf: controller.exportPdf,
              isExporting: controller.isExporting.value,
            );
          }),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

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
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: Get.back,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Text(
                  'Detail SOP',
                  style: AppTextStyles.h3Bold.copyWith(color: AppColors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HeaderCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        color: AppColors.welcomeFill,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.isEmpty ? 'SOP' : title, style: AppTextStyles.h3Bold),
          SizedBox(height: AppSpacing.xs.h),
          Text(subtitle, style: AppTextStyles.c1Regular),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final SopStep step;

  const _StepTile({required this.step});

  @override
  Widget build(BuildContext context) {
    final hasMeta = (step.pic != null && step.pic!.isNotEmpty) ||
        (step.durasi != null && step.durasi!.isNotEmpty);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28.r,
            height: 28.r,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.paleBlueFill,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${step.no}',
              style: AppTextStyles.c1Medium.copyWith(color: AppColors.primary),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.judul, style: AppTextStyles.p2Medium),
                if (step.deskripsi.isNotEmpty &&
                    step.deskripsi != step.judul) ...[
                  SizedBox(height: AppSpacing.xs.h),
                  Text(step.deskripsi, style: AppTextStyles.c1Regular),
                ],
                if (hasMeta) ...[
                  SizedBox(height: AppSpacing.sm.h),
                  _MetaBadge(pic: step.pic, durasi: step.durasi),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  final String? pic;
  final String? durasi;

  const _MetaBadge({this.pic, this.durasi});

  @override
  Widget build(BuildContext context) {
    final parts = <String>[
      if (pic != null && pic!.isNotEmpty) pic!,
      if (durasi != null && durasi!.isNotEmpty) durasi!,
    ];
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_outline_rounded,
              size: 13.sp, color: AppColors.success),
          SizedBox(width: AppSpacing.xs.w),
          Text(
            parts.join(' · '),
            style: AppTextStyles.c2Medium.copyWith(color: AppColors.success),
          ),
        ],
      ),
    );
  }
}

class _PlainSop extends StatelessWidget {
  final String text;

  const _PlainSop({required this.text});

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
      child: Text(text, style: AppTextStyles.p2Regular),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 48.sp, color: AppColors.iconMuted),
            SizedBox(height: AppSpacing.md.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.c1Regular,
            ),
            SizedBox(height: AppSpacing.lg.h),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onRetry,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl.w,
                  vertical: AppSpacing.sm.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Text(
                  'Coba lagi',
                  style: AppTextStyles.c1Medium
                      .copyWith(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  final VoidCallback onShare;
  final VoidCallback onCopy;
  final VoidCallback onPdf;
  final bool isExporting;

  const _ActionBar({
    required this.onShare,
    required this.onCopy,
    required this.onPdf,
    required this.isExporting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg.w,
        AppSpacing.md.h,
        AppSpacing.lg.w,
        AppSpacing.md.h,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: _OutlineButton(
                    icon: Icons.share_outlined,
                    label: 'Bagikan',
                    onTap: onShare,
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: _OutlineButton(
                    icon: Icons.copy_rounded,
                    label: 'Salin',
                    onTap: onCopy,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md.h),
            _PdfButton(onTap: onPdf, isLoading: isExporting),
          ],
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OutlineButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSpacing.radiusMd.r);
    return SizedBox(
      height: AppSpacing.buttonHeight.h,
      child: Material(
        color: AppColors.white,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: AppColors.primary),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.primary, size: 18.sp),
                SizedBox(width: AppSpacing.sm.w),
                Text(
                  label,
                  style: AppTextStyles.c1Medium
                      .copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PdfButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const _PdfButton({required this.onTap, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSpacing.radiusMd.r);
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isLoading
              ? AppColors.primaryDeep.withOpacity(0.6)
              : AppColors.primaryDeep,
          borderRadius: radius,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: radius,
            onTap: isLoading ? null : onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 18.sp,
                    height: 18.sp,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.white),
                    ),
                  )
                else
                  Icon(Icons.picture_as_pdf_outlined,
                      color: AppColors.white, size: 20.sp),
                SizedBox(width: AppSpacing.sm.w),
                Text(
                  isLoading ? 'Menyimpan...' : 'Simpan sebagai PDF',
                  style: AppTextStyles.button,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
