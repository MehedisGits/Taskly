import 'package:flutter/material.dart';

import 'get_device_type.dart';

double responsiveSize(BuildContext context,
    {double mobileSize = 16, double tabletSize = 18, double desktopSize = 24}) {
  if (DeviceType.isMobile(context)) {
    return mobileSize;
  } else if (DeviceType.isTablet(context)) {
    return tabletSize;
  } else {
    return desktopSize; // Desktop
  }
}
