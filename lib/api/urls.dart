import 'package:taskly/api/controller.dart';

final String baseUrl = 'http://35.73.30.144:2005/api/v1';
final Map<String, String> reqHeader = {
  "Content-Type": "application/json",
  "token": AuthController.accessToken.toString()
};
final String registrationUrl = '$baseUrl/Registration';
final String loginUrl = '$baseUrl/Login';
final String profileUpdateUrl = '$baseUrl/ProfileUpdate';
final String addNewTaskUrl = '$baseUrl/createTask';
