import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Reusable SOP row used on the Home ("SOP Terbaru") and Riwayat screens.
class SopCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String meta;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SopCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.meta = '',
    this.icon = Icons.description_rounded,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
        child: Container(
          padding: EdgeInsets.all(AppSpacing.lg.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSpacing.iconTile.r,
                height: AppSpacing.iconTile.r,
                decoration: BoxDecoration(
                  color: AppColors.iconTileBg,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20.sp),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.p2Medium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(subtitle, style: AppTextStyles.c1Regular),
                    if (meta.isNotEmpty) ...[
                      SizedBox(height: AppSpacing.sm.h),
                      Text(
                        meta,
                        style: AppTextStyles.c1Regular
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: AppSpacing.sm.w),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
