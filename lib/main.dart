import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/views/dashboard.dart';
import 'package:task_manager/views/onboardings/login_screen.dart';
import 'package:task_manager/views/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/routes.dart';
import 'core/themes/theme_data.dart';
import 'modules/auth/sign_up_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences before running the app
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put(sharedPreferences); // Using Get.put to register SharedPreferences

  runApp(DevicePreview(enabled: !kReleaseMode, builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Taskly',
      theme: ResponsiveTheme.getTheme(context),
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      home: DashboardScreen(),
      initialRoute: Routes.splash,
      getPages: [
        GetPage(name: Routes.splash, page: () => SplashScreen()),
        GetPage(name: Routes.home, page: () => DashboardScreen()),
        GetPage(name: Routes.signUp, page: () => SignUpScreen()),
        GetPage(name: Routes.login, page: () => LoginScreen()),
      ],
    );
  }
}
