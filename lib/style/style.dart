import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:taskly/utils/assetsPath.dart';

const colorRed = Color.fromRGBO(231, 28, 36, 1);
const colorDark = Color.fromRGBO(136, 28, 32, 1);
const colorGreen = Color.fromRGBO(33, 191, 115, 1);
const colorBlue = Color.fromRGBO(52, 152, 219, 1.0);
const colorOrange = Color.fromRGBO(230, 126, 34, 1);
const colorWhite = Color.fromRGBO(255, 255, 255, 1);
const colorDarkBlue = Color.fromRGBO(44, 62, 80, 1);
const colorLightGrey = Color.fromRGBO(135, 142, 150, 1);
const colorLight = Color.fromRGBO(211, 211, 211, 1);

TextStyle Heading1(textColor) {
  return TextStyle(
    fontFamily: 'poppins',
    color: textColor,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );
}

TextStyle Heading6(textColor) {
  return TextStyle(
    fontFamily: 'poppins',
    color: textColor,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
}

InputDecoration AppInputDecoration(String label) {
  return InputDecoration(
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green, width: 1),
    ),
    fillColor: colorWhite,
    filled: true,
    contentPadding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: colorWhite, width: 0.0),
    ),
    border: const OutlineInputBorder(),
    label: Text(label),
  );
}

DecoratedBox AppDropDownStyle(child) {
  return DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.white, width: 1),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: child,
    ),
  );
}

ButtonStyle AppButtonStyle() {
  return ElevatedButton.styleFrom(
    elevation: 1,
    padding: EdgeInsets.zero,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  );
}

TextStyle ButtonTextStyle() {
  return const TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
}

Ink SuccessButtonChild(String buttonText) {
  return Ink(
    decoration: BoxDecoration(
      color: colorGreen,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Container(
      height: 45,
      alignment: Alignment.center,
      child: Text(
        buttonText,
        style: ButtonTextStyle(),
      ),
    ),
  );
}

SizedBox ScreenBackground(context) {
  return SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: SvgPicture.asset(
      AssetsPath.backgroundSvg,
      alignment: Alignment.center,
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      fit: BoxFit.cover,
    ),
  );
}

void SuccessToast(msg) {
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor: colorGreen,
    textColor: colorWhite,
    fontSize: 16,
  );
}

void ErrorToast(msg) {
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor: colorRed,
    textColor: colorWhite,
    fontSize: 16,
  );
}

PinTheme AppOtpStyle() {
  return PinTheme(
    // Set a muted border color for inactive fields to reduce visual noise
    inactiveColor: colorGreen,
    inactiveFillColor: Colors.transparent,
    // Highlight selected fields with primary color as per Material guidelines
    selectedColor: colorBlue,
    selectedFillColor: Colors.blue.shade50,
    // Keep active fields consistent with background to reduce distractions
    activeColor: Colors.grey.shade300,
    activeFillColor: Colors.transparent,
    // Rounded corners for a Material feel
    borderRadius: BorderRadius.circular(8),
    // Add subtle shadow for elevation
    fieldHeight: 48,
    fieldWidth: 48,
    borderWidth: 1.0,
    shape: PinCodeFieldShape.box,
  );
}
