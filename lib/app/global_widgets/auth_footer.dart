import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class AuthFooter extends StatelessWidget {
  final String prompt;
  final String linkText;
  final VoidCallback onTap;

  const AuthFooter({
    super.key,
    required this.prompt,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: prompt,
        style: AppTextStyles.body(color: AppColors.gray),
        children: [
          TextSpan(
            text: linkText,
            style: AppTextStyles.link(),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
