import 'dart:io';
import 'package:flutter/material.dart';

class Device {
  static bool isKeyboard(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom != 0;
  }

  static bool isTablet(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.shortestSide;
    return deviceWidth > 600;
  }

  static bool isSmartphone(BuildContext context) {
    return !isTablet(context);
  }

  static bool isComputer(BuildContext context) {
    return Platform.isMacOS || Platform.isLinux || Platform.isWindows;
  }
}
