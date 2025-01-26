import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/utils/color_scheme.dart';
import 'package:task_manager/views/dashboard.dart';
import 'package:task_manager/views/onboardings/login_screen.dart';
import 'package:task_manager/views/onboardings/sign_up_screen.dart';

void main() {
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
      home: SignUpScreen(),
      initialRoute: Routes.login, // Set initial route
      getPages: [
        GetPage(name: Routes.home, page: () => DashboardScreen()),
        GetPage(name: Routes.signUp, page: () => SignUpScreen()),
        GetPage(name: Routes.login, page: () => LoginScreen()),
      ],
    );
  }
}

// routes.dart
class Routes {
  static const String home = '/home';
  static const String signUp = '/sign-up';
  static const String login = '/login';
}

