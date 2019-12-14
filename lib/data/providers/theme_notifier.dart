import 'package:FineWallet/color_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeNotifier({ThemeData theme}) : _theme = theme;

  ThemeData _theme;

  ThemeData get theme => _theme;

  Future switchTheme() async {
    if (_theme == standardTheme) {
      _theme = darkTheme;
    } else if (_theme == darkTheme) {
      _theme = standardTheme2;
    } else {
      _theme = standardTheme;
    }
    notifyListeners();
  }
}
