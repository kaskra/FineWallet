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
  cardTheme: CardTheme(color: _background),
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
  secondary: Colors.orange,
  secondaryVariant: Colors.white,
  surface: Color(0xFFFFFFFF),
  background: Color(0xFFFFFFFF),
  error: Colors.red,
  onPrimary: Colors.white,
  onSecondary: Color(0xFF151515),
  onSurface: Colors.white,
  onError: Color(0xFF151515),
  onBackground: Color(0xFF151515),
  brightness: Brightness.light,
);

final TextTheme textTheme = TextTheme(
  body2: TextStyle(color: Color(0xFF151515), fontFamily: "roboto"),
  caption: TextStyle(color: Color(0xFF151515), fontFamily: "roboto"),
  display1: TextStyle(color: Color(0xFF151515), fontFamily: "roboto"),
  display2: TextStyle(color: Color(0xFF151515), fontFamily: "roboto"),
  display3: TextStyle(color: Color(0xFF151515), fontFamily: "roboto"),
  display4: TextStyle(color: Color(0xFF151515), fontFamily: "roboto"),
  headline: TextStyle(color: Color(0xFF151515), fontFamily: "roboto"),
  overline: TextStyle(color: Color(0xFF151515), fontFamily: "roboto"),
  subhead: TextStyle(color: Color(0xFF151515), fontFamily: "roboto"),
  subtitle: TextStyle(color: Color(0xFF151515), fontFamily: "roboto"),
  title: TextStyle(color: Color(0xFF151515), fontFamily: "roboto"),
  body1: TextStyle(color: Color(0xFF151515), fontFamily: "roboto"),
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
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: colorScheme.secondary,
      backgroundColor: colorScheme.primary),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
  ),
  cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: colorScheme.background),
  dividerColor: Colors.black.withOpacity(0.5),
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
  iconTheme: IconThemeData(color: colorScheme.onSurface),
  hintColor: Color(0xFF212121),
);

final ColorScheme darkColorScheme = ColorScheme(
  primary: Color(0xFF212121),
  primaryVariant: Color(0xFF151515),
  secondary: Colors.orange,
  secondaryVariant: Color(0xFFc66900),
  surface: Color(0xFFFFFFFF),
  background: Color(0xFF212121),
  error: Colors.red,
  onPrimary: Colors.orange,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onError: Colors.white,
  onBackground: Colors.orange,
  brightness: Brightness.dark,
);

final TextTheme darkTextTheme = TextTheme(
  body2: TextStyle(color: darkColorScheme.secondary, fontFamily: "roboto"),
  caption: TextStyle(color: darkColorScheme.secondary, fontFamily: "roboto"),
  display1: TextStyle(color: darkColorScheme.secondary, fontFamily: "roboto"),
  display2: TextStyle(color: darkColorScheme.secondary, fontFamily: "roboto"),
  display3: TextStyle(color: darkColorScheme.secondary, fontFamily: "roboto"),
  display4: TextStyle(color: darkColorScheme.secondary, fontFamily: "roboto"),
  headline: TextStyle(color: darkColorScheme.secondary, fontFamily: "roboto"),
  overline: TextStyle(color: darkColorScheme.secondary, fontFamily: "roboto"),
  subhead: TextStyle(color: darkColorScheme.secondary, fontFamily: "roboto"),
  subtitle: TextStyle(color: darkColorScheme.secondary, fontFamily: "roboto"),
  title: TextStyle(color: darkColorScheme.secondary, fontFamily: "roboto"),
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
      color: darkColorScheme.background),
  dividerColor: Colors.orange,
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
  iconTheme: IconThemeData(color: colorScheme.onPrimary),
  hintColor: Color(0xFF212121),
);
