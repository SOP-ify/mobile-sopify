import 'package:get/get.dart';

import '../modules/botnavbar/bindings/botnavbar_binding.dart';
import '../modules/botnavbar/views/botnavbar_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/sop_create/bindings/sop_create_binding.dart';
import '../modules/sop_create/views/sop_create_view.dart';
import '../modules/sop_create_voice/bindings/sop_create_voice_binding.dart';
import '../modules/sop_create_voice/views/sop_create_voice_view.dart';
import '../modules/sop_detail/bindings/sop_detail_binding.dart';
import '../modules/sop_detail/views/sop_detail_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const BotNavBarView(),
      binding: BotNavBarBinding(),
    ),
    GetPage(
      name: _Paths.SOP_CREATE,
      page: () => const SopCreateView(),
      binding: SopCreateBinding(),
    ),
    GetPage(
      name: _Paths.SOP_CREATE_VOICE,
      page: () => const SopCreateVoiceView(),
      binding: SopCreateVoiceBinding(),
    ),
    GetPage(
      name: _Paths.SOP_DETAIL,
      page: () => const SopDetailView(),
      binding: SopDetailBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
  ];
}
