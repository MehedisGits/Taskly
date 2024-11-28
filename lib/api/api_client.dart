/*
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taskly/style/style.dart';

var baseURL = "http://35.73.30.144:2005/api/v1";
var reqHeader = {"Content-Type": "application/json"};

Future<bool> LoginRequest(formValues) async {
  Uri URL = Uri.parse("$baseURL/Login");
  var postBody = jsonDecode(formValues);
  var response = await http.post(URL, headers: reqHeader, body: postBody);
  int resultCode = response.statusCode;
  var resultBody = jsonDecode(response.body);
  if (resultCode == 200 && resultBody['status'] == 'success') {
    successToast("Request Success");
    return true;
  } else {
    errorToast("Request failed! try again");
    return false;
  }
}

Future<bool> RegistrationRequest(formValues) async {
  Uri URL = Uri.parse("$baseURL/Registration");
  var postBody = jsonEncode(formValues);
  var response = await http.post(URL, headers: reqHeader, body: postBody);
  int resultCode = response.statusCode;
  var resultBody = jsonDecode(response.body);

  if (resultCode == 200 && resultBody['status'] == "success") {
    successToast("Request success");
    return true;
  } else {
    errorToast("Request failed! try again");
    return false;
  }
}

Future<bool> VerifyEmailRequest(Email) async {
  Uri URL = Uri.parse("$baseURL/RecoverVerifyEmail/$Email");
  var response = await http.get(URL, headers: reqHeader);
  int resultCode = response.statusCode;
  var resultBody = jsonDecode(response.body);

  if (resultCode == 200 && resultBody['status'] == "success") {
    successToast("Request Success");
    return true;
  } else {
    errorToast("Request failed! try again");
    return false;
  }
}

Future<bool> VerifyOTPRequest(Email, OTP) async {
  Uri URL = Uri.parse("$baseURL/RecoverVerifyOtp/$Email/$OTP");

  var response = await http.get(URL, headers: reqHeader);

  int resultCode = response.statusCode;
  var resultBody = jsonDecode(response.body);

  if (resultCode == 200 && resultBody['status'] == "success") {
    successToast("Request Success");
    return true;
  } else {
    errorToast("Request failed! try again");
    return false;
  }
}

Future<bool> SetPasswordRequest(formValues) async {
  Uri URL = Uri.parse("$baseURL/RecoverResetPassword");

  var postBody = jsonEncode(formValues);

  var response = await http.post(URL, headers: reqHeader, body: postBody);

  int resultCode = response.statusCode;
  var resultBody = jsonDecode(response.body);

  if (resultCode == 200 && resultBody['status'] == "success") {
    successToast("Request Success");
    return true;
  } else {
    errorToast("Request failed! try again");
    return false;
  }
}
*/
