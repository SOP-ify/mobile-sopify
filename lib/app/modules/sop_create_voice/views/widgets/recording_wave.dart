import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

/// A lightweight animated equalizer shown while recording is active.
class RecordingWave extends StatefulWidget {
  final Color color;

  const RecordingWave({super.key, this.color = AppColors.danger});

  @override
  State<RecordingWave> createState() => _RecordingWaveState();
}

class _RecordingWaveState extends State<RecordingWave>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  static const int _barCount = 9;
  late final List<double> _phases;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    _phases = List.generate(_barCount, (i) => i * 0.7);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value * 2 * math.pi;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(_barCount, (i) {
              final v = (math.sin(t + _phases[i]) + 1) / 2; // 0..1
              final h = 8.h + v * 24.h;
              return Container(
                width: 4.w,
                height: h,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
