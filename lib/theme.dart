import 'package:flutter/material.dart';

ThemeData myTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    // Main Colors:
    primary: const Color.fromRGBO(255, 72, 72, 1.0),
    secondary: const Color.fromRGBO(195, 255, 135, 1.0),
    tertiary: const Color.fromRGBO(0, 0, 0, 0.75),

    // Colors:
    primaryContainer: const Color.fromRGBO(255, 72, 72, 0.75),
    secondaryContainer: const Color.fromRGBO(0, 0, 0, 0.5),
    tertiaryContainer: const Color.fromRGBO(0, 0, 0, 0.2),

    // Background Color:
    surface: Colors.orange[50]!,

    // Shadow Color:
    shadow: Colors.black87,

    // Border Color
    outline: Colors.redAccent[400],
  ),
  iconTheme: const IconThemeData(color: Colors.redAccent),
);
