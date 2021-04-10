/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:20:16 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const ColorScheme colorScheme = ColorScheme(
  primary: Colors.orange,
  primaryVariant: Colors.orange,
  onPrimary: Colors.white,
  //
  secondary: Colors.orange,
  secondaryVariant: Colors.white,
  onSecondary: Color(0xFF151515),
  //
  surface: Color(0xFF151515),
  onSurface: Colors.white,
  //
  background: Color(0xFFFFFFFF),
  onBackground: Color(0xFF151515),
  //
  error: Colors.red,
  onError: Color(0xFF151515),
  //
  brightness: Brightness.light,
);

const ColorScheme darkColorScheme = ColorScheme(
  primary: Color(0xFF212121),
  primaryVariant: Color(0xFF1a1a1a),
  onPrimary: Colors.orange,
  //
  secondary: Colors.orange,
  secondaryVariant: Color(0xFFc66900),
  onSecondary: Colors.white,
  //
  surface: Color(0xFF151515),
  onSurface: Colors.white,
  //
  background: Color(0xFF212121),
  onBackground: Colors.white,
  //
  error: Colors.red,
  onError: Colors.white,
  //
  brightness: Brightness.dark,
);

// ColorScheme.dark(
// primary: Color(0xffecba13),
// secondary: Color(0xffecba13),
// background: Color(0xff231f12),
// surface: Color(0xff2e2919),
//
// onPrimary: Color(0xff000000),
// onBackground: Color(0xffffffff),
// onSurface: Color(0xffffffff),
// )

// Depending on font some currency symbols my not be shown
const googleFonts = GoogleFonts.robotoSlabTextTheme;

TextTheme textTheme = googleFonts(const TextTheme(
  bodyText1: TextStyle(color: Color(0xFF151515)),
  caption: TextStyle(color: Color(0xFF151515)),
  headline4: TextStyle(color: Color(0xFF151515)),
  headline3: TextStyle(color: Color(0xFF151515)),
  headline2: TextStyle(color: Color(0xFF151515)),
  headline1: TextStyle(color: Color(0xFF151515)),
  headline5: TextStyle(color: Color(0xFF151515)),
  overline: TextStyle(color: Color(0xFF151515)),
  subtitle1: TextStyle(color: Color(0xFF151515)),
  subtitle2: TextStyle(color: Color(0xFF151515)),
  headline6: TextStyle(color: Color(0xFF151515)),
  bodyText2: TextStyle(color: Color(0xFF151515)),
  button: TextStyle(color: Color(0xFF151515)),
));

TextTheme darkTextTheme = googleFonts(const TextTheme(
  bodyText1: TextStyle(color: Colors.white),
  caption: TextStyle(color: Colors.white),
  headline4: TextStyle(color: Colors.white),
  headline3: TextStyle(color: Colors.white),
  headline2: TextStyle(color: Colors.white),
  headline1: TextStyle(color: Colors.white),
  headline5: TextStyle(color: Colors.white),
  overline: TextStyle(color: Colors.white),
  subtitle1: TextStyle(color: Colors.white),
  subtitle2: TextStyle(color: Colors.white),
  headline6: TextStyle(color: Colors.white),
  bodyText2: TextStyle(color: Colors.white),
  button: TextStyle(color: Colors.white),
));

final ThemeData standardTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: colorScheme,
  primaryColor: colorScheme.primary,
  accentColor: colorScheme.secondary,
  backgroundColor: colorScheme.background,
  scaffoldBackgroundColor: const Color(0xFFfaf0e6),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: colorScheme.secondary,
      backgroundColor: colorScheme.primary),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
  ),
  cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: BorderSide(width: 0, color: colorScheme.primary)),
      elevation: 4,
      color: colorScheme.background),
  dividerColor: Colors.black.withOpacity(0.5),
  textTheme: textTheme,
  primaryTextTheme: textTheme,
  accentTextTheme: textTheme,
  textSelectionTheme: TextSelectionThemeData(
      selectionColor: colorScheme.secondary.withOpacity(0.8),
      cursorColor: colorScheme.secondary,
      selectionHandleColor: colorScheme.secondary),
  sliderTheme: SliderThemeData(
    valueIndicatorColor: colorScheme.primary,
    inactiveTrackColor: colorScheme.primary.withOpacity(0.55),
    activeTrackColor: colorScheme.primary,
    thumbColor: colorScheme.primary,
  ),
  bottomAppBarColor: colorScheme.primary,
  iconTheme: IconThemeData(color: colorScheme.onSurface),
  hintColor: const Color(0xFF212121),
  appBarTheme: AppBarTheme(
      textTheme: textTheme.copyWith(
          headline6: textTheme.headline6.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 20)),
      iconTheme: IconThemeData(color: colorScheme.onSurface)),
  dialogTheme: DialogTheme(
    shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  primaryColor: darkColorScheme.primary,
  accentColor: darkColorScheme.secondary,
  backgroundColor: darkColorScheme.background,
  scaffoldBackgroundColor: darkColorScheme.primaryVariant,
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: darkColorScheme.onSecondary),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
  ),
  cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: BorderSide(width: 0, color: darkColorScheme.primary)),
      elevation: 4,
      color: darkColorScheme.background),
  dividerColor: Colors.white,
  textTheme: darkTextTheme,
  primaryTextTheme: darkTextTheme,
  accentTextTheme: darkTextTheme,
  textSelectionTheme: TextSelectionThemeData(
      selectionColor: darkColorScheme.secondary.withOpacity(0.8),
      cursorColor: darkColorScheme.secondary,
      selectionHandleColor: darkColorScheme.secondary),
  sliderTheme: SliderThemeData(
    valueIndicatorColor: darkColorScheme.secondary,
    inactiveTrackColor: darkColorScheme.secondary.withOpacity(0.55),
    activeTrackColor: darkColorScheme.secondary,
    thumbColor: darkColorScheme.secondary,
  ),
  bottomAppBarColor: darkColorScheme.primary,
  iconTheme: IconThemeData(color: colorScheme.onPrimary),
  hintColor: const Color(0xFF212121),
  canvasColor: const Color(0xFF292929),
  dialogBackgroundColor: darkColorScheme.primary,
  appBarTheme: AppBarTheme(
      textTheme: darkTextTheme.copyWith(
          headline6: darkTextTheme.headline6.copyWith(
              color: darkColorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 20)),
      iconTheme: IconThemeData(color: colorScheme.onSurface)),
  dialogTheme: DialogTheme(
    shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
  ),
);
