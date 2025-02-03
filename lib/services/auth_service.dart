import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  final SharedPreferences sharedPreferences;
  final RxBool isLoggedIn = false.obs;

  AuthService(this.sharedPreferences);

  /// Initialize authentication state
  Future<AuthService> init() async {
    _checkLoginStatus();
    return this;
  }

  /// Save user login token and update state
  Future<void> login({required String token}) async {
    await sharedPreferences.setString('token', token);
    isLoggedIn.value = true;
  }

  /// Logout user (removes token and redirects to login)
  Future<void> logout() async {
    await sharedPreferences.remove('token');
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }

  /// Check if user is logged in (valid token exists)
  void _checkLoginStatus() {
    isLoggedIn.value = sharedPreferences.getString('token')?.isNotEmpty ?? false;
  }
}
