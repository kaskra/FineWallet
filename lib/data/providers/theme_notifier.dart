import 'package:FineWallet/color_themes.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _theme;
  bool _isDarkMode;

  ThemeData get theme => _theme;

  bool get isDarkMode => _isDarkMode;

  Future switchTheme({@required bool dark}) async {
    _isDarkMode = dark;
    if (dark) {
      _theme = darkTheme;
      UserSettings.setDarkMode(val: true);
    } else {
      _theme = standardTheme;
      UserSettings.setDarkMode(val: false);
    }
    notifyListeners();
  }

  ThemeNotifier() {
    _theme = UserSettings.getDarkMode() ? darkTheme : standardTheme;
    _isDarkMode = UserSettings.getDarkMode();
  }
}
