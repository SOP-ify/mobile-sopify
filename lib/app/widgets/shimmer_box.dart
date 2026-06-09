import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

/// A single rounded placeholder block (used inside [AppShimmer]).
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;
  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius.r),
      ),
    );
  }
}

/// Wraps [child] with the app's shimmer animation.
class AppShimmer extends StatelessWidget {
  final Widget child;
  const AppShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.background,
      child: child,
    );
  }
}

/// Placeholder list of SOP cards shown while data loads.
class SopListShimmer extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry? padding;
  const SopListShimmer({super.key, this.itemCount = 6, this.padding});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: padding ??
            EdgeInsets.fromLTRB(
              AppSpacing.lg.w,
              AppSpacing.lg.h,
              AppSpacing.lg.w,
              AppSpacing.lg.h,
            ),
        itemCount: itemCount,
        separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md.h),
        itemBuilder: (_, __) => Container(
          padding: EdgeInsets.all(AppSpacing.lg.r),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
          ),
          child: Row(
            children: [
              ShimmerBox(
                width: 44.r,
                height: 44.r,
                radius: AppSpacing.radiusMd,
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 160.w, height: 12.h),
                    SizedBox(height: AppSpacing.sm.h),
                    ShimmerBox(width: 100.w, height: 10.h),
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
