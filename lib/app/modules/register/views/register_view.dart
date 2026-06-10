import 'package:flutter/gestures.dart';
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
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

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
              SizedBox(height: AppSpacing.xxl.h),
              Center(child: AppLogo(width: 110.w)),
              SizedBox(height: AppSpacing.xxl.h),
              AppTextField(
                label: 'Nama Lengkap',
                hint: 'Masukkan Nama Lengkap',
                controller: controller.nameController,
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: AppSpacing.lg.h),
              AppTextField(
                label: 'Alamat Email',
                hint: 'nama@gmail.com',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: AppSpacing.lg.h),
              AppTextField(
                label: 'Masukan No Telepon',
                hint: 'Masukan No Telepon',
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                prefixText: '+62 ',
              ),
              SizedBox(height: AppSpacing.lg.h),
              PasswordField(
                label: 'Kata Sandi',
                hint: 'Masukkan Kata Sandi',
                controller: controller.passwordController,
                fillColor: AppColors.paleBlueFill,
              ),
              SizedBox(height: AppSpacing.lg.h),
              _AgreeTerms(controller: controller),
              SizedBox(height: AppSpacing.xl.h),
              Obx(
                () => PrimaryButton(
                  label: 'Daftar',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.register,
                ),
              ),
              SizedBox(height: AppSpacing.xxl.h),
              Center(
                child: AuthFooter(
                  prompt: 'Sudah memiliki akun? ',
                  linkText: 'Masuk disini',
                  onTap: controller.goToLogin,
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

class _AgreeTerms extends StatelessWidget {
  final RegisterController controller;

  const _AgreeTerms({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => SizedBox(
            width: 22.w,
            height: 22.w,
            child: Checkbox(
              value: controller.agreeToTerms.value,
              onChanged: controller.toggleAgree,
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm.r),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Text.rich(
              TextSpan(
                text: 'Saya setuju dengan ',
                style: AppTextStyles.c1Regular
                    .copyWith(color: AppColors.textBody),
                children: [
                  TextSpan(
                    text: 'Syarat dan Ketentuan',
                    style: AppTextStyles.c1Medium
                        .copyWith(color: AppColors.primary),
                    recognizer: TapGestureRecognizer()
                      ..onTap = controller.openTerms,
                  ),
                  const TextSpan(text: ' serta kebijakan privasi SOP-ify.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
