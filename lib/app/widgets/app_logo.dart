import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/values/app_assets.dart';

/// SOP-ify brand logo (hexagon mark + wordmark).
class AppLogo extends StatelessWidget {
  final double? width;

  const AppLogo({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      width: width ?? 130.w,
      fit: BoxFit.contain,
    );
  }
}
