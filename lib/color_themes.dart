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

final ColorScheme colorScheme = ColorScheme(
  primary: Colors.orange,
  primaryVariant: Colors.orange,
  onPrimary: Colors.white,
  //
  secondary: Colors.orange,
  secondaryVariant: Colors.white,
  onSecondary: const Color(0xFF151515),
  //
  surface: const Color(0xFF151515),
  onSurface: Colors.white,
  //
  background: const Color(0xFFFFFFFF),
  onBackground: const Color(0xFF151515),
  //
  error: Colors.red,
  onError: const Color(0xFF151515),
  //
  brightness: Brightness.light,
);

final ColorScheme darkColorScheme = ColorScheme(
  primary: const Color(0xFF212121),
  primaryVariant: const Color(0xFF1a1a1a),
  onPrimary: Colors.orange,
  //
  secondary: Colors.orange,
  secondaryVariant: const Color(0xFFc66900),
  onSecondary: Colors.white,
  //
  surface: const Color(0xFF151515),
  onSurface: Colors.white,
  //
  background: const Color(0xFF212121),
  onBackground: Colors.white,
  //
  error: Colors.red,
  onError: Colors.white,
  //
  brightness: Brightness.dark,
);

const TextTheme textTheme = TextTheme(
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
  button: TextStyle(color: Color(0xFF151515), fontFamily: "roboto"),
);

const TextTheme darkTextTheme = TextTheme(
  body2: TextStyle(color: Colors.white, fontFamily: "roboto"),
  caption: TextStyle(color: Colors.white, fontFamily: "roboto"),
  display1: TextStyle(color: Colors.white, fontFamily: "roboto"),
  display2: TextStyle(color: Colors.white, fontFamily: "roboto"),
  display3: TextStyle(color: Colors.white, fontFamily: "roboto"),
  display4: TextStyle(color: Colors.white, fontFamily: "roboto"),
  headline: TextStyle(color: Colors.white, fontFamily: "roboto"),
  overline: TextStyle(color: Colors.white, fontFamily: "roboto"),
  subhead: TextStyle(color: Colors.white, fontFamily: "roboto"),
  subtitle: TextStyle(color: Colors.white, fontFamily: "roboto"),
  title: TextStyle(color: Colors.white, fontFamily: "roboto"),
  body1: TextStyle(color: Colors.white, fontFamily: "roboto"),
  button: TextStyle(color: Colors.white, fontFamily: "roboto"),
);

final ThemeData standardTheme = ThemeData(
  colorScheme: colorScheme,
  primaryColor: colorScheme.primary,
  accentColor: colorScheme.secondary,
  backgroundColor: colorScheme.background,
  scaffoldBackgroundColor: colorScheme.secondaryVariant,
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
      textTheme: TextTheme(
          title: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: "roboto")),
      iconTheme: IconThemeData(color: colorScheme.onSurface)),
);

final ThemeData darkTheme = ThemeData(
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
      textTheme: TextTheme(
          title: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: "roboto")),
      iconTheme: IconThemeData(color: colorScheme.onSurface)),
);
