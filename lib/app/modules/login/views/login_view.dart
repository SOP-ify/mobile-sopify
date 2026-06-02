import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/values/app_strings.dart';
import '../../../global_widgets/app_button.dart';
import '../../../global_widgets/app_logo.dart';
import '../../../global_widgets/app_text_field.dart';
import '../../../global_widgets/auth_footer.dart';
import '../../../global_widgets/welcome_banner.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeBanner(),
              SizedBox(height: 40.h),
              Center(child: AppLogo(width: 120.w)),
              SizedBox(height: 40.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: AppStrings.emailLabel,
                      hint: AppStrings.emailHint,
                      prefixIcon: Icons.mail_outline,
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20.h),
                    AppTextField(
                      label: AppStrings.passwordLabel,
                      hint: AppStrings.loginPasswordHint,
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      controller: controller.passwordController,
                    ),
                    SizedBox(height: 14.h),
                    _RememberRow(controller: controller),
                    SizedBox(height: 24.h),
                    AppButton(
                      label: AppStrings.loginButton,
                      onPressed: controller.login,
                    ),
                    SizedBox(height: 24.h),
                    Center(
                      child: AuthFooter(
                        prompt: AppStrings.noAccount,
                        linkText: AppStrings.registerLink,
                        onTap: controller.goToRegister,
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RememberRow extends StatelessWidget {
  final LoginController controller;

  const _RememberRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(
              () => SizedBox(
            width: 22.r,
            height: 22.r,
            child: Checkbox(
              value: controller.rememberMe.value,
              onChanged: controller.toggleRememberMe,
              activeColor: AppColors.deepBlue,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(AppStrings.rememberMe, style: AppTextStyles.body(color: AppColors.gray)),
        const Spacer(),
        GestureDetector(
          onTap: controller.forgotPassword,
          child: Text(AppStrings.forgotPassword, style: AppTextStyles.link()),
        ),
      ],
    );
  }
}
