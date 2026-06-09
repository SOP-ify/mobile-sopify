import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_logo.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/auth_footer.dart';
import '../../../widgets/password_field.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/welcome_banner.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl.w,
            vertical: AppSpacing.lg.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeBanner(),
              SizedBox(height: AppSpacing.xxxl.h),
              Center(child: AppLogo(width: 120.w)),
              SizedBox(height: AppSpacing.xxxl.h),
              AppTextField(
                label: 'Alamat Email',
                hint: 'Alamat Email',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outline_rounded,
              ),
              SizedBox(height: AppSpacing.lg.h),
              PasswordField(
                label: 'Kata Sandi',
                hint: 'Masukkan kata sandi',
                controller: controller.passwordController,
                prefixIcon: Icons.lock_outline_rounded,
              ),
              SizedBox(height: AppSpacing.md.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _RememberMe(controller: controller)),
                  GestureDetector(
                    onTap: controller.onForgotPassword,
                    child: Text(
                      'Lupa Kata Sandi?',
                      style: AppTextStyles.c1Medium
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl.h),
              Obx(
                () => PrimaryButton(
                  label: 'Masuk',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.login,
                ),
              ),
              SizedBox(height: AppSpacing.xxl.h),
              Center(
                child: AuthFooter(
                  prompt: 'Belum punya akun? ',
                  linkText: 'Klik daftar',
                  onTap: controller.goToRegister,
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _RememberMe extends StatelessWidget {
  final LoginController controller;

  const _RememberMe({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(
          () => SizedBox(
            width: 22.w,
            height: 22.w,
            child: Checkbox(
              value: controller.rememberMe.value,
              onChanged: controller.toggleRemember,
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm.r),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm.w),
        Flexible(
          child: Text(
            'Ingat saya?',
            style: AppTextStyles.c1Regular.copyWith(color: AppColors.textBody),
          ),
        ),
      ],
    );
  }
}
