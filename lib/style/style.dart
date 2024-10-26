// Import necessary Flutter and third-party packages
import 'package:flutter/material.dart'; // Provides Material Design components and utilities
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Used to display toast messages

// Define custom colors as constants for a consistent color scheme across the app
const colorRed = Color.fromRGBO(231, 28, 36, 1); // Primary red color
const colorDark = Color.fromRGBO(136, 28, 32, 1); // Darker shade of red
const colorGreen = Color.fromRGBO(33, 191, 115, 1); // Primary green color
const colorBlue = Color.fromRGBO(52, 152, 219, 1.0); // Primary blue color
const colorOrange = Color.fromRGBO(230, 126, 34, 1); // Primary orange color
const colorWhite = Color.fromRGBO(255, 255, 255, 1); // White color
const colorDarkBlue = Color.fromRGBO(44, 62, 80, 1); // Dark blue color
const colorLightGrey =
    Color.fromRGBO(135, 142, 150, 1); // Light grey color for neutral elements
const colorLight = Color.fromRGBO(
    211, 211, 211, 1); // Light grey color for backgrounds or borders

// Define custom text styles for headers and other important text
TextStyle Heading1(textColor) {
  return TextStyle(
    fontFamily: 'poppins',
    color: textColor, // Dynamic color input
    fontSize: 28, // Large fonts size for main headings
    fontWeight: FontWeight.w700, // Bold weight for emphasis
  );
}

TextStyle Heading6(textColor) {
  return TextStyle(
    fontFamily: 'poppins',
    color: textColor, // Dynamic color input
    fontSize: 16, // Smaller fonts size for subheadings
    fontWeight: FontWeight.w700, // Bold weight
  );
}

// Define a custom input decoration style for text fields
InputDecoration AppInputDecoration(String label) {
  return InputDecoration(
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
          color: Colors.green, width: 1), // Border color when focused
    ),
    fillColor: colorWhite,
    // Background color
    filled: true,
    // Enables fill color
    contentPadding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
    // Padding inside the input field
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
          color: colorWhite, width: 0.0), // Border color when not focused
    ),
    border: const OutlineInputBorder(),
    // Default border
    label: Text(label), // Dynamic label input
  );
}

// Define a custom dropdown style for consistent design across dropdowns
DecoratedBox AppDropDownStyle(child) {
  return DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white,
      // Background color
      border: Border.all(color: Colors.white, width: 1),
      // Border color and width
      borderRadius: BorderRadius.circular(4), // Rounded border corners
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      // Horizontal padding for child widget
      child: child, // Dropdown child widget
    ),
  );
}

// Define a reusable button style for consistent button appearance
ButtonStyle AppButtonStyle() {
  return ElevatedButton.styleFrom(
      elevation: 1, // Button elevation for shadow effect
      padding: EdgeInsets.zero, // Zero padding for custom styling
      backgroundColor: Colors.transparent, // Transparent background
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6))); // Rounded corners
}

// Define a text style specifically for button text
TextStyle ButtonTextStyle() {
  return TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w400); // Button fonts style
}

// Define a reusable success button design with custom style
Ink SuccessButtonChild(String buttonText) {
  return Ink(
    decoration: BoxDecoration(
        color: colorGreen, // Green background for success indication
        borderRadius: BorderRadius.circular(6)), // Rounded corners
    child: Container(
      height: 45, // Fixed height for the button
      alignment: Alignment.center, // Center align text
      child: Text(
        buttonText,
        style: ButtonTextStyle(), // Use defined button text style
      ),
    ),
  );
}

SizedBox ScreenBackground(context) {
  return SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: SvgPicture.asset(
      'assets/images/background.svg',
      alignment: Alignment.center,
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      fit: BoxFit.cover,
    ),
  );
}

// Display a success toast message with predefined style
void SuccessToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      // Message to display
      gravity: ToastGravity.BOTTOM,
      // Position of toast on screen
      timeInSecForIosWeb: 1,
      // Duration for iOS
      toastLength: Toast.LENGTH_SHORT,
      // Duration of toast
      backgroundColor: colorGreen,
      // Background color
      textColor: colorWhite,
      // Text color
      fontSize: 16); // Font size of toast message
}

// Display an error toast message with predefined style
void ErrorToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      // Error message to display
      gravity: ToastGravity.BOTTOM,
      // Position of toast on screen
      timeInSecForIosWeb: 1,
      // Duration for iOS
      toastLength: Toast.LENGTH_SHORT,
      // Duration of toast
      backgroundColor: colorRed,
      // Background color for error
      textColor: colorWhite,
      // Text color
      fontSize: 16); // Font size of error message
}
