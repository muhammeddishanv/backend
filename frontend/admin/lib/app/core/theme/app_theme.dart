import 'package:flutter/material.dart';

// Centralized theme configuration for the admin app.
// The app uses Flutter's modern Material 3 theming system and creates
// a light and dark ThemeData from a shared seed color. Adjusting the
// seed color will harmonize the app's primary/accent colors automatically.
const Color _seedColor = Colors.lightBlue;

// Light theme used as the default appearance. Keep this lightweight —
// widget-specific styling should be applied locally when necessary.
final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.light,
  ),
  // App-wide font; ensure the font is included in assets and pubspec.yaml
  fontFamily: 'Urbanist',
  // Use Material 3 design language for more modern widgets and defaults
  useMaterial3: true,
);

// Dark theme counterpart. The same seed color is reused so brand colors
// remain consistent between light and dark modes.
final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.dark,
  ),
  fontFamily: 'Urbanist',
  useMaterial3: true,
);
