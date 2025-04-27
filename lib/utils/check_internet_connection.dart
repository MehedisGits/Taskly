import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Check internet connectivity
Future<bool> checkInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return false; // No internet connection
  }
  return true; // Internet connection is available
}

// Check token validity
Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token'); // Replace 'auth_token' with your token key
}

Future<bool> isTokenValid(String? token) async {
  // You can add your token validation logic here. For example, check if the token is expired.
  if (token == null || token.isEmpty) {
    return false; // Token is not valid
  }
  return true; // Token is valid
}
