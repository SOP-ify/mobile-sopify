import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

class BottomNavItemData {
  final IconData icon;
  final String label;
  const BottomNavItemData(this.icon, this.label);
}

/// Bottom navigation bar for the main app shell (Beranda / Riwayat / Profil).
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  static const List<BottomNavItemData> items = [
    BottomNavItemData(Icons.home_rounded, 'Beranda'),
    BottomNavItemData(Icons.history_rounded, 'Riwayat'),
    BottomNavItemData(Icons.person_outline_rounded, 'Profil'),
  ];

  const AppBottomNavBar({super.key, this.currentIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final active = index == currentIndex;
              final color = active ? AppColors.primary : AppColors.navInactive;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap?.call(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(items[index].icon, color: color, size: 24.sp),
                    SizedBox(height: AppSpacing.xs.h),
                    Text(
                      items[index].label,
                      style: AppTextStyles.c2Medium.copyWith(
                        color: color,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
