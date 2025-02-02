import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/routes.dart';
import 'core/theme_data.dart'; // Ensure this file exists and contains the necessary themes.
import 'modules/auth/login_screen.dart';
import 'modules/auth/sign_up_screen.dart';
import 'modules/profile/profile_screen.dart';
import 'modules/tasks/add_or_edit_tasks.dart';
import 'controllers/user_controller.dart';
import 'views/dashboard.dart';
import 'views/splash_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  // Ensure bindings are initialized before running the app
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

  /// **Safe way to get the theme mode**
  ThemeMode _getThemeMode() {
    // Ensure `UserController` is registered before calling `Get.find`
    if (Get.isRegistered<UserController>()) {
      return Get.find<UserController>().isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
    } else {
      return ThemeMode.light; // Default theme to avoid errors
    }
  }
}

/// **Centralized route management**
class AppPages {
  static final List<GetPage> routes = [
    GetPage(name: Routes.splash, page: () => SplashScreen()),
    GetPage(name: Routes.home, page: () => DashboardScreen()),
    GetPage(name: Routes.signUp, page: () => SignUpScreen()),
    GetPage(name: Routes.login, page: () => LoginScreen()),
    GetPage(name: Routes.addNewTask, page: () => AddNewTasksScreen()),
    GetPage(name: Routes.profile, page: () => ProfileScreen()),
  ];
}

/// **Dependency injection using GetX bindings**
class AppBindings extends Bindings {
  final SharedPreferences sharedPreferences;
  AppBindings({required this.sharedPreferences});

  @override
  void dependencies() {
    // Register SharedPreferences
    Get.put<SharedPreferences>(sharedPreferences, permanent: true);

    // Initialize and register AuthService
    Get.putAsync<AuthService>(() async => await AuthService(sharedPreferences).init());

    // Ensure UserController is registered before accessing it
    if (!Get.isRegistered<UserController>()) {
      Get.put<UserController>(UserController(), permanent: true);
    }
  }
}
