import 'package:flutter/material.dart';

class DeviceType {
  // Determines if the device is Mobile based on screen width
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  // Determines if the device is Tablet based on screen width
  static bool isTablet(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }

  // Determines if the device is Desktop based on screen width
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  // Checks if the device is in Portrait orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // Checks if the device is in Landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Gets the current device type as a String
  static String getDeviceType(BuildContext context) {
    if (isMobile(context)) {
      return "Mobile";
    } else if (isTablet(context)) {
      return "Tablet";
    } else {
      return "Desktop";
    }
  }

  // Get custom breakpoints if needed (for flexibility)
  static bool isCustomMobile(BuildContext context,
      {double maxMobileWidth = 600}) {
    return MediaQuery.of(context).size.width < maxMobileWidth;
  }

  static bool isCustomTablet(BuildContext context,
      {double minTabletWidth = 600, double maxTabletWidth = 1024}) {
    double width = MediaQuery.of(context).size.width;
    return width >= minTabletWidth && width < maxTabletWidth;
  }

  static bool isCustomDesktop(BuildContext context,
      {double minDesktopWidth = 1024}) {
    return MediaQuery.of(context).size.width >= minDesktopWidth;
  }
}
