import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  late SharedPreferences _sharedPreferences;
  final RxBool isLoggedIn = false.obs;

  /// Initialize the AuthService and check login status
  Future<AuthService> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _checkLoginStatus();
    return this;
  }

  /// Save user login token and update login state
  Future<void> login({required String token}) async {
    try {
      await _sharedPreferences.setString('token', token);
      isLoggedIn.value = true;
    } catch (e) {
      Get.snackbar(
        'Login Error',
        'Failed to save login token. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Logout user by removing token and redirecting to login screen
  Future<void> logout() async {
    try {
      // Clear all SharedPreferences
      await _sharedPreferences.clear();

      // Reset any GetX states or controllers
      Get.deleteAll(force: true);

      // Optionally reset other singleton services if you have any (example: AuthService)
      Get.reset(); // Reset GetX (controller + services) if you want even harder reset

      // Navigate to Login screen with a fresh clean start
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Logout Error',
        'Failed to log out. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Check if user is logged in by verifying the token
  void _checkLoginStatus() {
    final token = _sharedPreferences.getString('token');
    isLoggedIn.value = token != null && token.isNotEmpty;
  }

  /// Retrieve the saved token
  String? getToken() {
    return _sharedPreferences.getString('token');
  }

  /// Clear all user data (useful for account deletion or app reset)
  Future<void> clearUserData() async {
    try {
      await _sharedPreferences.clear();
      isLoggedIn.value = false;
      Get.offAllNamed('/login'); // Redirect to login screen
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to clear user data. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Check if the token is valid (placeholder for actual validation logic)
  Future<bool> isTokenValid() async {
    final token = getToken();
    if (token == null || token.isEmpty) {
      return false;
    }
    // Add actual token validation logic here (e.g., API call)
    return true;
  }
}
