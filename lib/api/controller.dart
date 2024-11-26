import 'package:shared_preferences/shared_preferences.dart';

/// AuthController manages user authentication data, such as the access token.
/// It uses SharedPreferences to persist data locally and provides utility methods
/// to save, retrieve, and clear the authentication state.

class AuthController {
  // Key used to store the access token in SharedPreferences.
  static final String _accessTokenKey = 'access-token';

  // A static variable to hold the in-memory copy of the access token for quick access.
  static String? accessToken;

  /// Saves the access token to both SharedPreferences and the in-memory variable.
  /// This ensures persistence across app sessions.
  ///
  /// [token]: The access token to save.
  static Future<void> saveAccessToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    accessToken = token; // Update the in-memory token.
  }

  /// Retrieves the access token from SharedPreferences.
  /// The value is also stored in the in-memory variable for subsequent quick access.
  ///
  /// Returns the access token as a String, or null if it doesn't exist.
  static Future<String?> getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    accessToken = token; // Update the in-memory token.
    return token;
  }

  /// Checks if the user is currently logged in by verifying if the access token exists.
  ///
  /// Returns true if the access token is not null, indicating a logged-in state.
  static bool isLoggedIn() {
    return accessToken != null;
  }

  /// Clears all user-related data from SharedPreferences, including the access token.
  /// Also sets the in-memory token to null to indicate a logged-out state.
  static Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear(); // Removes all stored data.
    accessToken = null; // Reset the in-memory token.
  }
}
