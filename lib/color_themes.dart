/*
 * Developed by Lukas Krauch 29.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:flutter/material.dart';

final ThemeData normalTheme = ThemeData(
    textSelectionColor: Colors.black26,
    primarySwatch: Colors.orange,
    appBarTheme:
        AppBarTheme(actionsIconTheme: IconThemeData(color: Colors.white)));

const double appBarElevation = 0; // default 4
const double appBarOpacity = 1;
const bool centerAppBar = true;

const _primary = Colors.orange;
const _secondary = Colors.orangeAccent;
const _onMainColor = Colors.white;
const _errorColor = Colors.red;
const _onBackground = Colors.black;
const _background = Colors.white;
const _negBudget = Colors.red;
const _overallBackground = Color(0xffd8e7ff);
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
    body1: TextStyle(color: _onBackground.withOpacity(0.87)),
    button: TextStyle(color: _onMainColor),
  ),
  iconTheme: IconThemeData(color: _onMainColor),
  accentTextTheme: TextTheme(body1: TextStyle(color: _negBudget)),
  scaffoldBackgroundColor: _overallBackground, //// Colors.white,
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
    onSurface: _onBackground.withOpacity(0.54),
    onBackground: _onBackground,
    onSecondary: _onMainColor,
    error: _errorColor,
  ),
);
