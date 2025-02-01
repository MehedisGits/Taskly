import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/routes/routes.dart';
import 'core/themes/theme_data.dart';
import 'modules/auth/login_screen.dart';
import 'modules/auth/sign_up_screen.dart';
import 'modules/profile/profile_screen.dart';
import 'modules/tasks/add_or_edit_tasks.dart';
import 'modules/profile/user_controller.dart';
import 'views/dashboard.dart';
import 'views/splash_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(sharedPreferences: sharedPreferences),
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => GetMaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        title: 'Taskly',
        theme: ResponsiveTheme.getTheme(context),
        darkTheme: ThemeData.dark(),
        themeMode: _getThemeMode(),
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        initialRoute: Routes.splash,
        getPages: AppPages.routes,
        initialBinding: AppBindings(sharedPreferences: sharedPreferences),
      ),
    );
  }

  ThemeMode _getThemeMode() {
    final userController = UserController();
    return userController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
  }
}

/// Centralized route management
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

/// Dependency injection using GetX bindings
class AppBindings extends Bindings {
  final SharedPreferences sharedPreferences;

  AppBindings({required this.sharedPreferences});

  @override
  void dependencies() {
    // Register SharedPreferences as a dependency
    Get.put(sharedPreferences, permanent: true);

    // Asynchronously initialize AuthService and register it as a dependency
    Get.putAsync<AuthService>(() async => await AuthService(sharedPreferences).init());

    // Register other controllers/services
    Get.put(UserController(), permanent: true);
  }
}
