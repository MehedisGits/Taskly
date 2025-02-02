import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/user_controller.dart';
import 'core/app_binding.dart';
import 'core/app_pages.dart';
import 'core/routes.dart';
import 'core/theme_data.dart';
import 'modules/auth/login_screen.dart';
import 'modules/auth/sign_up_screen.dart';
import 'modules/profile/profile_screen.dart';
import 'modules/tasks/add_or_edit_tasks.dart';
import 'services/auth_service.dart';
import 'views/dashboard.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize and bind dependencies before app starts
  AppBindings(sharedPreferences: sharedPreferences).dependencies();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(sharedPreferences: sharedPreferences),
    ),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Taskly',
      theme: ResponsiveTheme.getLightTheme(context),
      darkTheme: ResponsiveTheme.getDarkTheme(context),
      themeMode: _getThemeMode(),
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      initialRoute: Routes.splash,
      getPages: AppPages.routes,
    );
  }

  ThemeMode _getThemeMode() {
    // Ensure UserController is registered before calling Get.find
    if (Get.isRegistered<UserController>()) {
      return Get.find<UserController>().isDarkMode.value
          ? ThemeMode.dark
          : ThemeMode.light;
    } else {
      return ThemeMode.light; // Default theme to avoid errors
    }
  }
}
