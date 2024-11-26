import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:taskly/utils/assetsPath.dart';

/// Color constants
const colorRed = Color.fromRGBO(231, 28, 36, 1);
const colorDark = Color.fromRGBO(136, 28, 32, 1);
const colorGreen = Color.fromRGBO(33, 191, 115, 1);
const colorBlue = Color.fromRGBO(52, 152, 219, 1.0);
const colorOrange = Color.fromRGBO(230, 126, 34, 1);
const colorWhite = Color.fromRGBO(255, 255, 255, 1);
const colorDarkBlue = Color.fromRGBO(44, 62, 80, 1);
const colorLightGrey = Color.fromRGBO(135, 142, 150, 1);
const colorLight = Color.fromRGBO(211, 211, 211, 1);

/// Text style for Heading1
TextStyle heading1({required Color textColor}) {
  return TextStyle(
    fontFamily: 'Poppins',
    color: textColor,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );
}

/// Text style for Heading6
TextStyle heading6({required Color textColor}) {
  return TextStyle(
    fontFamily: 'Poppins',
    color: textColor,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
}

/// Input decoration for TextFields
InputDecoration appInputDecoration(String label) {
  return InputDecoration(
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: colorGreen, width: 1),
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

/// Decorated box style for dropdowns
DecoratedBox appDropDownStyle(Widget child) {
  return DecoratedBox(
    decoration: BoxDecoration(
      color: colorWhite,
      border: Border.all(color: colorWhite, width: 1),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: child,
    ),
  );
}

/// Button style for primary actions
ButtonStyle appButtonStyle() {
  return ElevatedButton.styleFrom(
    elevation: 1,
    padding: EdgeInsets.zero,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  );
}

/// Text style for button text
TextStyle buttonTextStyle() {
  return const TextStyle(
    color: colorWhite,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
}

/// Success button child widget
Ink successButtonChild(String buttonText) {
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
        style: buttonTextStyle(),
      ),
    ),
  );
}

/// Background with a scalable SVG
SizedBox screenBackground(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: SvgPicture.asset(
      AssetsPath.backgroundSvg,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.cover,
    ),
  );
}

/// Success toast message
void successToast(String msg) {
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

/// Error toast message
void errorToast(String msg) {
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

/// Pin Code Input Field Style
PinTheme appOtpStyle() {
  return PinTheme(
    inactiveColor: colorGreen,
    inactiveFillColor: Colors.transparent,
    selectedColor: colorBlue,
    selectedFillColor: Colors.blue.shade50,
    activeColor: Colors.grey.shade300,
    activeFillColor: Colors.transparent,
    borderRadius: BorderRadius.circular(8),
    fieldHeight: 48,
    fieldWidth: 48,
    borderWidth: 1.0,
    shape: PinCodeFieldShape.box,
  );
}
