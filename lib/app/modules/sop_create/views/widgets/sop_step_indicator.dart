import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

enum _NodeState { done, active, upcoming }

/// The dynamic "1 — 2 — 3" progress header.
///
/// Colors change with [currentStep] (1..3): completed nodes turn green with a
/// check, the active node is blue, upcoming nodes stay grey. The connectors
/// between completed steps turn green too.
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
    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < 3; i++) ...[
              _Node(state: _stateFor(i), number: i + 1),
              if (i < 2)
                Expanded(
                  child: _Connector(filled: (i + 1) < currentStep),
                ),
            ],
          ],
        ),
        SizedBox(height: AppSpacing.sm.h),
        Row(
          children: [
            for (int i = 0; i < 3; i++) ...[
              SizedBox(
                width: 32.r,
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: AppTextStyles.c2Medium.copyWith(
                    color: _stateFor(i) == _NodeState.upcoming
                        ? AppColors.navInactive
                        : (_stateFor(i) == _NodeState.done
                            ? AppColors.success
                            : AppColors.primary),
                  ),
                ),
              ),
              if (i < 2) const Expanded(child: SizedBox.shrink()),
            ],
          ],
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

  const _Connector({required this.filled});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.h,
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs.w),
      color: filled ? AppColors.success : AppColors.border,
    );
  }
}
