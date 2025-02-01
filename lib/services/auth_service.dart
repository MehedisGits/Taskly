import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  final SharedPreferences prefs;
  final RxBool isLoggedIn = false.obs;

  AuthService(this.prefs);

  /// Initialize authentication state
  Future<AuthService> init() async {
    _checkLoginStatus();
    return this;
  }

  /// Save user login token and update state
  Future<void> login(String token) async {
    await prefs.setString('auth_token', token);
    isLoggedIn.value = true;
  }

  /// Logout user (removes token and redirects to login)
  Future<void> logout() async {
    await prefs.remove('auth_token');
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }

  /// Check if user is logged in (valid token exists)
  void _checkLoginStatus() {
    isLoggedIn.value = prefs.getString('auth_token')?.isNotEmpty ?? false;
  }
}
