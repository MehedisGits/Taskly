import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/profile/controller/user_controller.dart';
import '../services/auth_service.dart';

class AppBindings extends Bindings {
  final SharedPreferences sharedPreferences;

  AppBindings({required this.sharedPreferences});

  @override
  void dependencies() {
    // Register SharedPreferences as a permanent dependency
    Get.put<SharedPreferences>(sharedPreferences, permanent: true);

    // Initialize and register AuthService asynchronously
    Get.putAsync<AuthService>(
        () async => AuthService());

    // Register UserController only if not already registered
    if (!Get.isRegistered<UserController>()) {
      Get.put<UserController>(UserController(), permanent: true);
    }
  }
}
