import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/theme/app_theme.dart';
import 'app/data/repositories/auth_repository.dart';
import 'app/data/services/auth_service.dart';
import 'app/data/services/connectivity_service.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment config (API base URL). A missing .env is non-fatal —
  // ApiClient falls back to the hosted backend URL.
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {}
  await GetStorage.init();
  await Get.putAsync<AuthService>(() => AuthService().init());
  await Get.putAsync<ConnectivityService>(() => ConnectivityService().init());
  Get.put<AuthRepository>(AuthRepository());
  runApp(const SopifyApp());
}

class SopifyApp extends StatelessWidget {
  const SopifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'SOP-ify',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
