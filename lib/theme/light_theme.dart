import 'package:flutter/material.dart';

ThemeData light({Color? primaryColor, Color? secondaryColor}) => ThemeData(
      fontFamily: 'TitilliumWeb',
      primaryColor: primaryColor ?? const Color(0xFFD99F5F), // base
      brightness: Brightness.light,
      highlightColor: Colors.white,
      hintColor: const Color(0xFF5E5E5E),
      splashColor: Colors.transparent,
      colorScheme: ColorScheme.light(
        primary: const Color(0xFFD99F5F), // base
        secondary: const Color(0xFFB37744), // darker shade
        outline: const Color(0xFFFFE3C7), // lighter shade
        tertiary: const Color(0xFFF9D4A8),
        tertiaryContainer: const Color(0xFFFFF5E9),
        onTertiaryContainer: const Color(0xFF33AF74),
        onPrimary: const Color.fromARGB(255, 148, 100, 23),
        surface: const Color(0xFFF4F8FF),
        onSecondary: secondaryColor ?? const Color(0xFFF88030),
        error: const Color(0xFFFF5555),
        onSecondaryContainer: const Color(0xFFF3F9FF),
        onTertiary: const Color(0xFFE9F3FF),
        primaryContainer: const Color(0xFF9AECC6),
        secondaryContainer: const Color(0xFFF2F2F2),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
        TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
      }),
    );
