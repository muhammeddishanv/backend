import 'package:flutter/material.dart';

const Color _seedColor = Colors.lightBlue;

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.light,
  ),
  fontFamily: 'Urbanist',
  useMaterial3: true,
);

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.dark,
  ),
  fontFamily: 'Urbanist',
  useMaterial3: true,
);
