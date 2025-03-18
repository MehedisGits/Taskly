// ignore_for_file: unused_import

import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/modules/auth/login_screen.dart';
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

//Taskly Main App
//This is the main entry point of the Taskly app. It initializes the app with the GetMaterialApp widget and sets the theme, title, and initial route. It also registers the routes for the app using GetPage.
//The app uses the DevicePreview package to enable device preview for the app. This allows developers to preview the app on different devices and screen sizes during development.
//The app also registers the SharedPreferences instance using Get.put to make it available throughout the app.
//The main function initializes the app by calling WidgetsFlutterBinding.ensureInitialized() and then runs the app using runApp(DevicePreview(enabled: !kReleaseMode, builder: (context) => MyApp())).
//The MyApp widget is a stateless widget that returns a GetMaterialApp widget with the app configuration and routes.
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
