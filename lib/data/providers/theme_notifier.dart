import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/themes.dart';
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
      _theme = colorTheme;
      UserSettings.setDarkMode(val: true);
    } else {
      _theme = colorTheme;
      UserSettings.setDarkMode(val: false);
    }
    notifyListeners();
  }

  ThemeNotifier() {
    _theme = UserSettings.getDarkMode() ? colorTheme : colorTheme;
    _isDarkMode = UserSettings.getDarkMode();
  }
}
