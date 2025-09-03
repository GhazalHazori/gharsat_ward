import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Amiri Regular',
  primaryColor: const Color(0xFFD99F5F), // base
  brightness: Brightness.dark,
  highlightColor: const Color(0xFF252525),
  hintColor: const Color(0xFFc7c7c7),
  cardColor: const Color(0xFF242424),
  scaffoldBackgroundColor: const Color(0xFF000000),
  splashColor: Colors.transparent,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFD99F5F), // base
    secondary: Color(0xFFB37744), // darker shade
    outline: Color(0xFFFFE3C7), // lighter shade
    tertiary: Color(0xFF865C0A),
    tertiaryContainer: Color(0xFF6C7A8E),
    surface: Color(0xFF2D2D2D),
    onPrimary: Color.fromARGB(255, 102, 64, 4),
    onTertiaryContainer: Color(0xFF0F5835),
    primaryContainer: Color(0xFF208458),
    onSecondaryContainer: Color(0x912A2A2A),
    onTertiary: Color(0xFF545252),
    secondaryContainer: Color(0xFFF2F2F2),
    surfaceContainer: Color(0xFFFB6C4C),
  ),
  textTheme: const TextTheme(bodyLarge: TextStyle(color: Color(0xFFE9EEF4))),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
