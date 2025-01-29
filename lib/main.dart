import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskly/views/add_new_tasks_screen.dart';

import 'core/routes/routes.dart';
import 'core/themes/theme_data.dart';
import 'views/dashboard.dart';
import 'views/onboardings/login_screen.dart';
import 'views/onboardings/sign_up_screen.dart';
import 'views/onboardings/splash_screen.dart';

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
      home: DashboardScreen(),
      initialRoute: Routes.splash,
      getPages: [
        GetPage(name: Routes.splash, page: () => SplashScreen()),
        GetPage(name: Routes.home, page: () => DashboardScreen()),
        GetPage(name: Routes.signUp, page: () => SignUpScreen()),
        GetPage(name: Routes.login, page: () => LoginScreen()),
        GetPage(name: Routes.addNewTask, page: () => AddNewTasksScreen()),
      ],
    );
  }
}
