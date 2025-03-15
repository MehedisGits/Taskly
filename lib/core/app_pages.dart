import 'package:get/get.dart';
import 'package:task_manager/core/routes.dart';

import '../modules/auth/login_screen.dart';
import '../modules/auth/sign_up_screen.dart';
import '../modules/profile/profile_screen.dart';
import '../views/dashboard.dart';
import '../views/splash_screen.dart';

class AppPages {
  static final List<GetPage> routes = [
    GetPage(name: Routes.splash, page: () => SplashScreen()),
    GetPage(name: Routes.home, page: () => DashboardScreen()),
    GetPage(name: Routes.signUp, page: () => SignUpScreen()),
    GetPage(name: Routes.login, page: () => LoginScreen()),
    // GetPage(name: Routes.addNewTask, page: () => AddNewTasksScreen()),
    GetPage(name: Routes.profile, page: () => ProfileScreen()),
  ];
}
