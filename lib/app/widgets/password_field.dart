import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import 'app_input_decoration.dart';
import 'field_label.dart';

/// A labeled password field with its own visibility toggle.
class PasswordField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final Color? fillColor;

  const PasswordField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.prefixIcon,
    this.fillColor,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(widget.label),
        TextField(
          controller: widget.controller,
          obscureText: _obscure,
          style: AppTextStyles.input,
          decoration: appInputDecoration(
            hint: widget.hint,
            fillColor: widget.fillColor,
            prefixIcon: widget.prefixIcon == null
                ? null
                : Icon(widget.prefixIcon,
                    color: AppColors.iconMuted, size: 20.sp),
            suffixIcon: IconButton(
              splashRadius: 20.r,
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(
                _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.iconMuted,
                size: 20.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
