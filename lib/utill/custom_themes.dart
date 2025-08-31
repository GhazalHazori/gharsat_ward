import 'package:flutter/material.dart';
import 'package:gharsat_ward/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

const titilliumRegular = TextStyle(
  fontFamily: 'Tajawal',
  fontSize: 12,
);
const titleRegular = TextStyle(
  fontFamily: 'Tajawal',
  fontWeight: FontWeight.w500,
  fontSize: 14,
);
const titleHeader = TextStyle(
  fontFamily: 'Tajawal',
  fontWeight: FontWeight.w600,
  fontSize: 16,
);
const titilliumSemiBold = TextStyle(
  fontFamily: 'Tajawal',
  fontSize: 12,
  fontWeight: FontWeight.w600,
);

const titilliumBold = TextStyle(
  fontFamily: 'Tajawal',
  fontSize: 14,
  fontWeight: FontWeight.w700,
);
const titilliumItalic = TextStyle(
  fontFamily: 'Tajawal',
  fontSize: 14,
  fontStyle: FontStyle.italic,
);

const textRegular = TextStyle(
  fontFamily: 'Tajawal',
  fontWeight: FontWeight.w300,
  fontSize: 14,
);

const textMedium = TextStyle(
  fontFamily: 'Tajawal',
  fontSize: 14,
  fontWeight: FontWeight.w500,
);
const textBold = TextStyle(
  fontFamily: 'Tajawal',
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

const robotoBold = TextStyle(
  fontFamily: 'Tajawal',
  fontSize: 14,
  fontWeight: FontWeight.w700,
);

class ThemeShadow {
  static List<BoxShadow> getShadow(BuildContext context) {
    List<BoxShadow> boxShadow = [
      BoxShadow(
        color: Provider.of<ThemeController>(context, listen: false).darkTheme
            ? Colors.black26
            : Theme.of(context).primaryColor.withValues(alpha: .075),
        blurRadius: 5,
        spreadRadius: 1,
        offset: const Offset(1, 1),
      ),
    ];
    return boxShadow;
  }
}
