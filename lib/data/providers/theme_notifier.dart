import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ColorScheme _theme;
  bool _isDarkMode;

  ColorScheme get theme => _theme;

  bool get isDarkMode => _isDarkMode;

  Future switchTheme({@required bool dark}) async {
    _isDarkMode = dark;
    if (dark) {
      _theme = darkColorScheme;
      UserSettings.setDarkMode(val: true);
    } else {
      _theme = lightColorScheme;
      UserSettings.setDarkMode(val: false);
    }
    notifyListeners();
  }

  ThemeNotifier() {
    _theme = UserSettings.getDarkMode() ? darkColorScheme : lightColorScheme;
    _isDarkMode = UserSettings.getDarkMode();
  }
}
