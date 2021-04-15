import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const colorScheme = ColorScheme.light(
  primary: Color(0xffff9800),
  secondary: Color(0xfffb992a),
  background: Color(0xfffaf0e6),
  surface: Color(0xffffffff),
  onPrimary: Color(0xff000000),
  onBackground: Color(0xff000000),
  onSurface: Color(0xff000000),
);

// const colorScheme = ColorScheme.dark(
//   primary: Color(0xffda3cc5),
//   secondary: Color(0xffda3cc5),
//   background: Color(0xff211520),
//   surface: Color(0xff2d1e2c),
//   onPrimary: Color(0xffffffff),
//   onBackground: Color(0xffffffff),
//   onSurface: Color(0xffffffff),
// );

// Depending on font some currency symbols my not be shown
const googleFonts = GoogleFonts.notoSansTextTheme;
// const googleFonts = GoogleFonts.notoSerifTextTheme;

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

final colorTheme =
    ThemeData.from(colorScheme: colorScheme, textTheme: textTheme);
