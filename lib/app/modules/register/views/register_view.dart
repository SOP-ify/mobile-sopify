import 'package:flutter/gestures.dart';
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
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

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
              SizedBox(height: 28.h),
              Center(child: AppLogo(width: 120.w)),
              SizedBox(height: 28.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: AppStrings.nameLabel,
                      hint: AppStrings.nameHint,
                      controller: controller.nameController,
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      label: AppStrings.emailLabel,
                      hint: AppStrings.registerEmailHint,
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      label: AppStrings.phoneLabel,
                      hint: AppStrings.phoneHint,
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      label: AppStrings.passwordLabel,
                      hint: AppStrings.registerPasswordHint,
                      isPassword: true,
                      fillColor: AppColors.paleBlueBG,
                      controller: controller.passwordController,
                    ),
                    SizedBox(height: 16.h),
                    _AgreeRow(controller: controller),
                    SizedBox(height: 24.h),
                    AppButton(
                      label: AppStrings.registerButton,
                      onPressed: controller.register,
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: AuthFooter(
                        prompt: AppStrings.haveAccount,
                        linkText: AppStrings.loginLink,
                        onTap: controller.goToLogin,
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

class _AgreeRow extends StatelessWidget {
  final RegisterController controller;

  const _AgreeRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
              () => SizedBox(
            width: 22.r,
            height: 22.r,
            child: Checkbox(
              value: controller.agreeTerms.value,
              onChanged: controller.toggleAgree,
              activeColor: AppColors.deepBlue,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Text.rich(
              TextSpan(
                text: AppStrings.agreePrefix,
                style: AppTextStyles.body(color: AppColors.charcoal),
                children: [
                  TextSpan(
                    text: AppStrings.agreeTerms,
                    style: AppTextStyles.link(),
                    recognizer: TapGestureRecognizer()..onTap = controller.openTerms,
                  ),
                  TextSpan(text: AppStrings.agreeSuffix),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
