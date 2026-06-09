import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/sop_categories.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../widgets/app_input_decoration.dart';
import '../../../../widgets/field_label.dart';
import '../../../../widgets/primary_button.dart';

/// A multi-line note field with a live character counter, used for the
/// procedure text. Reuses the shared input decoration.
class SopNoteField extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;
  final int currentLength;
  final String label;
  final String hint;

  const SopNoteField({
    super.key,
    required this.controller,
    required this.maxLength,
    required this.currentLength,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) FieldLabel(label),
        TextField(
          controller: controller,
          maxLines: 6,
          maxLength: maxLength,
          buildCounter: (_,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          style: AppTextStyles.input,
          decoration: appInputDecoration(hint: hint),
        ),
        SizedBox(height: AppSpacing.xs.h),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$currentLength / $maxLength karakter',
            style: AppTextStyles.c2Regular,
          ),
        ),
      ],
    );
  }
}

/// Shared bottom CTA container used by the input + result stages.
class SopBottomBar extends StatelessWidget {
  final Widget child;

  const SopBottomBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xxxl.w,
        AppSpacing.md.h,
        AppSpacing.xxxl.w,
        AppSpacing.xl.h,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}

/// Selectable "Bidang usaha" chips shared by the text + voice input forms.
class SopCategoryChips extends StatelessWidget {
  final List<SopCategory> categories;
  final String selected;
  final ValueChanged<String> onSelect;

  /// When true the chips lay out in a single horizontally-scrolling row
  /// instead of wrapping onto multiple lines.
  final bool horizontal;

  const SopCategoryChips({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelect,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (horizontal) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final c in categories)
              Padding(
                padding: EdgeInsets.only(right: AppSpacing.sm.w),
                child: _CategoryChip(
                  label: c.label,
                  selected: selected == c.value,
                  onTap: () => onSelect(c.value),
                ),
              ),
          ],
        ),
      );
    }
    return Wrap(
      spacing: AppSpacing.sm.w,
      runSpacing: AppSpacing.sm.h,
      children: categories
          .map(
            (c) => _CategoryChip(
              label: c.label,
              selected: selected == c.value,
              onTap: () => onSelect(c.value),
            ),
          )
          .toList(),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSpacing.radiusXl.r);
    return Material(
      color: selected ? AppColors.paleBlueFill : AppColors.white,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg.w,
            vertical: AppSpacing.sm.h,
          ),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.c1Medium.copyWith(
              color: selected ? AppColors.primary : AppColors.textBody,
            ),
          ),
        ),
      ),
    );
  }
}

/// A primary button with a leading icon, matching the mockups
/// ("Generate SOP Sekarang" / "Simpan ke Daftar SOP").
class IconPrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color color;

  const IconPrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.isLoading = false,
    this.color = AppColors.primaryDeep,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return PrimaryButton(
        label: label,
        isLoading: true,
        color: color,
        onPressed: onPressed,
      );
    }
    final radius = BorderRadius.circular(AppSpacing.radiusMd.r);
    final enabled = onPressed != null;
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: enabled ? color : color.withOpacity(0.6),
          borderRadius: radius,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: radius,
            onTap: enabled ? onPressed : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.white, size: 20.sp),
                SizedBox(width: AppSpacing.sm.w),
                Text(label, style: AppTextStyles.button),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
