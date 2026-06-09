import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/relative_time.dart';
import '../../../data/models/sop_model.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/shimmer_box.dart';
import '../../../widgets/sop_card.dart';
import '../../botnavbar/controllers/botnavbar_controller.dart';
import '../controllers/riwayat_controller.dart';

class RiwayatView extends GetView<RiwayatController> {
  const RiwayatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const _Header(),
          _SearchBar(onChanged: controller.onSearch),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.isEmpty) {
                return const SopListShimmer();
              }
              if (controller.error.value.isNotEmpty && controller.isEmpty) {
                return _CenteredMessage(
                  icon: Icons.cloud_off_rounded,
                  message: controller.error.value,
                );
              }
              if (controller.isEmpty) {
                return _CenteredMessage(
                  icon: Icons.history_rounded,
                  message: controller.query.value.isEmpty
                      ? 'Belum ada riwayat SOP.'
                      : 'Tidak ada SOP yang cocok.',
                );
              }

              final groups = controller.grouped;
              final children = <Widget>[];
              groups.forEach((bucket, items) {
                children.add(
                  Padding(
                    padding: EdgeInsets.only(
                      top: AppSpacing.lg.h,
                      bottom: AppSpacing.sm.h,
                    ),
                    child: Text(
                      bucket,
                      style: AppTextStyles.c2Medium
                          .copyWith(color: AppColors.textSecondary, letterSpacing: 0.5),
                    ),
                  ),
                );
                for (final sop in items) {
                  children.add(
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.md.h),
                      child: _RiwayatCard(sop: sop),
                    ),
                  );
                }
              });

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: controller.load,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg.w,
                    0,
                    AppSpacing.lg.w,
                    AppSpacing.xxl.h,
                  ),
                  children: children,
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
                onTap: () {
                  if (Get.isRegistered<BotNavBarController>()) {
                    Get.find<BotNavBarController>().changePage(0);
                  }
                },
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Text(
                'Riwayat',
                style: AppTextStyles.h3Bold.copyWith(color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg.w,
        AppSpacing.lg.h,
        AppSpacing.lg.w,
        AppSpacing.xs.h,
      ),
      child: Container(
        height: AppSpacing.fieldHeight.h,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: AppColors.iconMuted, size: 20.sp),
            SizedBox(width: AppSpacing.sm.w),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                style: AppTextStyles.input,
                cursorColor: AppColors.primary,
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Cari riwayat SOP...',
                  hintStyle: AppTextStyles.hint,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiwayatCard extends StatelessWidget {
  final SopModel sop;
  const _RiwayatCard({required this.sop});

  @override
  Widget build(BuildContext context) {
    return SopCard(
      title: sop.sopName,
      subtitle: sop.kategori,
      meta: '${timeAgo(sop.createdAt)} · ${sop.stepCount} langkah',
      onTap: () => Get.toNamed(Routes.SOP_DETAIL, arguments: sop),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.iconMuted,
        size: 20.sp,
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  final IconData icon;
  final String message;
  const _CenteredMessage({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 120.h),
        Icon(icon, size: 48.sp, color: AppColors.iconMuted),
        SizedBox(height: AppSpacing.md.h),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.c1Regular,
        ),
      ],
    );
  }
}
