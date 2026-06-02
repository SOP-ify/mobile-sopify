import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/values/app_strings.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 16.h),
      decoration: const BoxDecoration(
        color: AppColors.paleBlueBG,
        border: Border(
          bottom: BorderSide(color: AppColors.borderGray),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppStrings.welcomeTitle, style: AppTextStyles.h2()),
          SizedBox(height: 6.h),
          Text(
            AppStrings.welcomeSubtitle,
            style: AppTextStyles.body(color: AppColors.gray),
          ),
        ],
      ),
    );
  }
}
