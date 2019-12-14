/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:20:16 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:flutter/material.dart';

const _primary = Colors.orange;
const _secondary = Colors.orangeAccent;
const _onMainColor = Colors.white;
const _errorColor = Colors.red;
const _onBackground = Colors.black;
const _background = Colors.white;
const _negBudget = Colors.red;
const _overallBackground = Colors.white; //Color(0xffd8e7ff);
const _brightness = Brightness.light;

final ThemeData standardTheme = ThemeData(
  primaryColor: _primary,
  primaryColorDark: _primary.shade700,
  textSelectionColor: _onBackground.withOpacity(0.15),
  cursorColor: _onBackground.withOpacity(0.26),
  cardColor: _background,
  accentColor: _secondary,
  buttonColor: _secondary,
  textTheme: TextTheme(
    body1:
        TextStyle(color: _onBackground.withOpacity(0.87), fontFamily: "roboto"),
    button: TextStyle(color: _onMainColor),
  ),
  iconTheme: IconThemeData(color: _onMainColor),
  accentTextTheme: TextTheme(body1: TextStyle(color: _negBudget)),
  scaffoldBackgroundColor: _overallBackground,
  canvasColor: _background,
  colorScheme: ColorScheme(
    primary: _primary,
    primaryVariant: _primary.shade700,
    secondary: _secondary,
    secondaryVariant: _secondary.shade400,
    surface: _primary,
    background: _background,
    brightness: _brightness,
    onError: _onMainColor,
    onPrimary: _onMainColor,
    onSurface: _onBackground.withOpacity(0.7),
    onBackground: _onBackground,
    onSecondary: _onMainColor,
    error: _errorColor,
  ),
);

final ColorScheme colorScheme = ColorScheme(
  primary: Colors.orange,
  primaryVariant: Colors.orange,
  secondary: Colors.white,
  secondaryVariant: Colors.white,
  surface: Color(0xFFFFFFFF),
  background: Color(0xFFFFFFFF),
  error: Color(0xFFBB0000),
  onPrimary: Colors.white,
  onSecondary: Colors.black.withOpacity(0.87),
  onSurface: Colors.black.withOpacity(0.87),
  onError: Color(0xFF000000),
  onBackground: Colors.black.withOpacity(0.87),
  brightness: Brightness.light,
);

final TextTheme textTheme = TextTheme(
//  body2: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  caption: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  display1: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  display2: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  display3: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  display4: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  headline: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  overline: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  subhead: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  subtitle: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  title: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
  body1: TextStyle(color: colorScheme.secondary, fontFamily: "roboto"),
  button: TextStyle(color: Color(0xFFffc947)),
);

final ThemeData standardTheme2 = ThemeData(
  colorScheme: colorScheme,
  primaryColor: colorScheme.primary,
  accentColor: colorScheme.secondary,
  backgroundColor: colorScheme.background,
  scaffoldBackgroundColor: colorScheme.secondaryVariant,
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((4))),
  ),
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(foregroundColor: colorScheme.onSecondary),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
  ),
  cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: colorScheme.background),
  dividerColor: Color(0xFF000000),
  textTheme: textTheme,
  primaryTextTheme: textTheme,
  accentTextTheme: textTheme,
  sliderTheme: SliderThemeData(
    valueIndicatorColor: colorScheme.primary,
    inactiveTrackColor: colorScheme.primary.withOpacity(0.55),
    activeTrackColor: colorScheme.primary,
    thumbColor: colorScheme.primary,
  ),
  bottomAppBarColor: colorScheme.primary,
);

final ColorScheme darkColorScheme = ColorScheme(
  primary: Color(0xFF212121),
  primaryVariant: Color(0xFF151515),
  secondary: Color(0xFFff9800),
  secondaryVariant: Color(0xFFc66900),
  surface: Color(0xFFFFFFFF),
  background: Color(0xFFFFFFFF),
  error: Color(0xFFB00020),
  onPrimary: Color(0xFFFFFFFF),
  onSecondary: Color(0xFFFFFFFF),
  onSurface: Color(0xFF151515),
  onError: Color(0xFFFFFFFF),
  onBackground: Color(0xFF151515),
  brightness: Brightness.dark,
);

final TextTheme darkTextTheme = TextTheme(
//  body2: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  caption: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  display1: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  display2: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  display3: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  display4: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  headline: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  overline: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  subhead: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  subtitle: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
//  title: TextStyle(color: Color(0xFFff9800), fontFamily: "roboto"),
  body1: TextStyle(color: darkColorScheme.secondary, fontFamily: "roboto"),
  button: TextStyle(color: Color(0xFFffc947)),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: darkColorScheme,
  primaryColor: darkColorScheme.primary,
  accentColor: darkColorScheme.secondary,
  backgroundColor: darkColorScheme.background,
  scaffoldBackgroundColor: darkColorScheme.primaryVariant,
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((4))),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: darkColorScheme.onSecondary),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
  ),
  cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: darkColorScheme.primary),
  dividerColor: Color(0xFF000000),
  textTheme: darkTextTheme,
  primaryTextTheme: darkTextTheme,
  accentTextTheme: darkTextTheme,
  sliderTheme: SliderThemeData(
    valueIndicatorColor: darkColorScheme.secondary,
    inactiveTrackColor: darkColorScheme.secondary.withOpacity(0.55),
    activeTrackColor: darkColorScheme.secondary,
    thumbColor: darkColorScheme.secondary,
  ),
  bottomAppBarColor: darkColorScheme.primary,
);
