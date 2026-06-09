import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Consistent label shown above an input field.
class FieldLabel extends StatelessWidget {
  final String text;

  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
      child: Text(text, style: AppTextStyles.fieldLabel),
    );
  }
}
