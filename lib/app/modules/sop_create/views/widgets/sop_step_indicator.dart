import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

enum _NodeState { done, active, upcoming }

class SopStepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> labels;

  const SopStepIndicator({
    super.key,
    required this.currentStep,
    this.labels = const ['Tulis Prosedur', 'Proses', 'Selesai'],
  });

  _NodeState _stateFor(int index) {
    final step = index + 1;
    if (step < currentStep) return _NodeState.done;
    if (step == currentStep) {
      return currentStep == 3 ? _NodeState.done : _NodeState.active;
    }
    return _NodeState.upcoming;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < 3; i++)
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 32.r,
                  child: Row(
                    children: [
                      // Left half of the connector coming from the previous node.
                      Expanded(
                        child: i == 0
                            ? const SizedBox.shrink()
                            : _Connector(
                          filled: i < currentStep,
                          margin: EdgeInsets.only(right: AppSpacing.xs.w),
                        ),
                      ),
                      _Node(state: _stateFor(i), number: i + 1),
                      // Right half of the connector going to the next node.
                      Expanded(
                        child: i == 2
                            ? const SizedBox.shrink()
                            : _Connector(
                          filled: (i + 1) < currentStep,
                          margin: EdgeInsets.only(left: AppSpacing.xs.w),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.sm.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs.w),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: AppTextStyles.c2Medium.copyWith(
                      color: _stateFor(i) == _NodeState.upcoming
                          ? AppColors.navInactive
                          : (_stateFor(i) == _NodeState.done
                          ? AppColors.success
                          : AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Node extends StatelessWidget {
  final _NodeState state;
  final int number;

  const _Node({required this.state, required this.number});

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    late final Color borderColor;
    switch (state) {
      case _NodeState.done:
        bg = AppColors.success;
        fg = AppColors.white;
        borderColor = AppColors.success;
        break;
      case _NodeState.active:
        bg = AppColors.primary;
        fg = AppColors.white;
        borderColor = AppColors.primary;
        break;
      case _NodeState.upcoming:
        bg = AppColors.white;
        fg = AppColors.navInactive;
        borderColor = AppColors.border;
        break;
    }

    return Container(
      width: 32.r,
      height: 32.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: state == _NodeState.done
          ? Icon(Icons.check_rounded, color: fg, size: 18.sp)
          : Text(
        '$number',
        style: AppTextStyles.c1Medium.copyWith(color: fg),
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  final bool filled;
  final EdgeInsetsGeometry margin;

  const _Connector({required this.filled, required this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.h,
      margin: margin,
      color: filled ? AppColors.success : AppColors.border,
    );
  }
}