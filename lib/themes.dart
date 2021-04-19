import 'package:FineWallet/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const lightColorScheme = ColorScheme.light(
  background: Color(0xfffaf0e6),
  // surface: Color(0xffffffff),
  primary: Color(0xffff9800),
  secondary: Color(0xffff9800),
  // onBackground: Color(0xff000000),
  // onSurface: Color(0xff000000),
  // onPrimary: Color(0xffffffff),
  onSecondary: Color(0xffffffff),
);

const darkColorScheme = ColorScheme.dark(
  // background: Color(0xff121212),
  // surface: Color(0xff121212),
  primary: Color(0xffff9800),
  secondary: Color(0xffff9800),
  // onBackground: Color(0xffffffff),
  // onSurface: Color(0xffffffff),
  onPrimary: Color(0xffffffff),
  onSecondary: Color(0xffffffff),
);

// Depending on font some currency symbols my not be shown
const googleFonts = GoogleFonts.notoSansTextTheme;
// const googleFonts = GoogleFonts.notoSerifTextTheme;

TextTheme _getTextTheme(bool isDark) {
  return googleFonts(const TextTheme(
    headline1: TextStyle(
      fontSize: 95,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
    ),
    headline2: TextStyle(
      fontSize: 59,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
    ),
    headline3: TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w400,
    ),
    headline4: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    headline5: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
    ),
    headline6: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    subtitle1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
    ),
    subtitle2: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyText1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    button: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
    ),
    caption: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    overline: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
    ),
  ));
}

ThemeData getTheme(ColorScheme colorScheme) {
  final bool isDark = colorScheme.brightness == Brightness.dark;
  final TextTheme textTheme = _getTextTheme(isDark);

  return ThemeData.from(colorScheme: colorScheme, textTheme: textTheme)
      .copyWith(
    // applyElevationOverlayColor: true,
    cardTheme: CardTheme(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      color: colorScheme.surface,
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.only(left: 12, right: 12),
      filled: true,
      fillColor: isDark ? const Color(0x0affffff) : const Color(0x0a000000),
      border: const OutlineInputBorder(),
      suffixStyle: const TextStyle(fontSize: 16),
      errorStyle: const TextStyle(fontSize: 11),
    ),
    appBarTheme: AppBarTheme(
      elevation: 4,
      centerTitle: true,
      textTheme: textTheme,
      titleTextStyle: textTheme.headline6.copyWith(color: Colors.white),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      elevation: 4,
      color: isDark ? colorScheme.surface : colorScheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
      ),
    ),
    iconTheme: IconThemeData(
      color: colorScheme.onSecondary,
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
    ),
  );
}
