import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_dialogs.dart';
import '../../../core/utils/relative_time.dart';
import '../../../data/models/sop_model.dart';
import '../../../widgets/sop_card.dart';
import '../../botnavbar/controllers/botnavbar_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _Header(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.recentSops.isEmpty &&
                  controller.totalSop.value == 0) {
                return const Center(child: CircularProgressIndicator());
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
                    _Greeting(name: controller.userName),
                    SizedBox(height: AppSpacing.xl.h),
                    Text('Ringkasan Usaha Anda', style: AppTextStyles.h4Bold),
                    SizedBox(height: AppSpacing.md.h),
                    _TotalSopCard(total: controller.totalSop.value),
                    SizedBox(height: AppSpacing.xl.h),
                    const _CreateSopCard(),
                    SizedBox(height: AppSpacing.xl.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text('SOP Terbaru', style: AppTextStyles.h4Bold),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (Get.isRegistered<BotNavBarController>()) {
                              Get.find<BotNavBarController>().changePage(1);
                            }
                          },
                          child: Text(
                            'Lihat Semua',
                            style: AppTextStyles.c1Medium
                                .copyWith(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    if (controller.error.value.isNotEmpty &&
                        controller.recentSops.isEmpty)
                      _InfoText(controller.error.value)
                    else if (controller.recentSops.isEmpty)
                      const _InfoText(
                        'Belum ada SOP. Mulai buat SOP pertama Anda.',
                      )
                    else
                      ...controller.recentSops.map(
                        (sop) => Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.md.h),
                          child: _RecentSopCard(sop: sop),
                        ),
                      ),
                    SizedBox(height: AppSpacing.sm.h),
                    const _TipsCard(),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
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
              Icon(Icons.bolt_rounded, color: AppColors.white, size: 26.sp),
              SizedBox(width: AppSpacing.sm.w),
              Text(
                'SOP-ify',
                style: AppTextStyles.brand(size: 22, color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  final String name;
  const _Greeting({required this.name});

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
          Text('Halo, $name', style: AppTextStyles.h3Bold),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            'Selamat datang kembali di SOP-ify',
            style: AppTextStyles.c1Regular,
          ),
        ],
      ),
    );
  }
}

class _TotalSopCard extends StatelessWidget {
  final int total;
  const _TotalSopCard({required this.total});

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
      child: Row(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: AppColors.iconTileBg,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
            ),
            child: Icon(
              Icons.description_rounded,
              color: AppColors.primary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: AppSpacing.lg.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL SOP',
                style: AppTextStyles.c2Medium
                    .copyWith(color: AppColors.textSecondary, letterSpacing: 0.5),
              ),
              SizedBox(height: AppSpacing.xs.h),
              Text(
                '$total',
                style: AppTextStyles.brand(size: 30, color: AppColors.textPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreateSopCard extends StatelessWidget {
  const _CreateSopCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.xl.r),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Buat SOP Sekarang',
            style: AppTextStyles.h4Bold.copyWith(color: AppColors.white),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            'Tulis atau rekam prosedur usaha Anda, AI akan menyusunnya untuk Anda.',
            style: AppTextStyles.c1Regular.copyWith(
              color: AppColors.white.withOpacity(0.85),
            ),
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            children: [
              Expanded(
                child: _CreateButton(
                  icon: Icons.edit_outlined,
                  label: 'Tulis Prosedur',
                  onTap: () => AppDialogs.info(
                    'Fitur tulis prosedur segera hadir.',
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: _CreateButton(
                  icon: Icons.mic_none_rounded,
                  label: 'Rekam Suara',
                  onTap: () => AppDialogs.info(
                    'Fitur rekam suara segera hadir.',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _CreateButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSpacing.radiusMd.r);
    return Material(
      color: AppColors.white.withOpacity(0.12),
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: AppColors.white.withOpacity(0.6)),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.white, size: 22.sp),
              SizedBox(height: AppSpacing.xs.h),
              Text(
                label,
                style: AppTextStyles.c1Medium.copyWith(color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentSopCard extends StatelessWidget {
  final SopModel sop;
  const _RecentSopCard({required this.sop});

  @override
  Widget build(BuildContext context) {
    return SopCard(
      title: sop.sopName,
      subtitle: sop.kategori,
      meta: '${timeAgo(sop.createdAt)} · ${sop.stepCount} langkah',
      onTap: () => AppDialogs.info('Detail SOP segera hadir.'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm.w,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.successBg,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm.r),
            ),
            child: Text(
              'AKTIF',
              style: AppTextStyles.c2Medium.copyWith(color: AppColors.success),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.iconMuted,
            size: 20.sp,
          ),
        ],
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: AppColors.warning,
            size: 22.sp,
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tips Produktif', style: AppTextStyles.p2Medium),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  'Buat SOP untuk tugas yang sering berulang agar tim Anda bekerja lebih konsisten.',
                  style: AppTextStyles.c1Regular,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoText extends StatelessWidget {
  final String text;
  const _InfoText(this.text);

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
      child: Text(
        text,
        style: AppTextStyles.c1Regular,
        textAlign: TextAlign.center,
      ),
    );
  }
}
