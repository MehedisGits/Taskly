// Corrected import path

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/strings.dart';
import 'package:task_manager/modules/profile/controller/user_controller.dart';
import 'package:task_manager/core/routes.dart';
import 'package:task_manager/dashboard.dart';
import 'package:task_manager/modules/auth/controller/login_controller.dart';
import 'package:task_manager/modules/auth/views/login_screen.dart';
import 'package:task_manager/modules/auth/views/sign_up_screen.dart';
import 'package:task_manager/modules/onboarding/splash_screen.dart';
import 'package:task_manager/modules/profile/view/profile_screen.dart';
import 'package:task_manager/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences before running the app
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put(sharedPreferences); // Using Get.put to register SharedPreferences
  Get.put(UserController()); // Registering the user controller
  Get.put(AuthService()); // Registering the auth service
  Get.put(LoginController());

  runApp(DevicePreview(enabled: !kReleaseMode, builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: AppStrings.appName,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      //ResponsiveTheme.getTheme(context),
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      home: DashboardScreen(),
      // Ensure this class is defined
      initialRoute: Routes.splash,
      getPages: [
        GetPage(name: Routes.splash, page: () => SplashScreen()),
        GetPage(name: Routes.home, page: () => DashboardScreen()),
        // Ensure this class is defined
        GetPage(name: Routes.signUp, page: () => SignUpScreen()),
        GetPage(name: Routes.login, page: () => LoginScreen()),
        GetPage(name: Routes.profile, page: () => ProfileScreen()),
        // Ensure this class is defined
      ],
    );
  }
}
