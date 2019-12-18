import 'package:FineWallet/color_themes.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _theme;

  ThemeData get theme => _theme;

  Future switchTheme({@required dark}) async {
    if (dark) {
      _theme = darkTheme;
      UserSettings.setDarkMode(true);
    } else {
      _theme = standardTheme;
      UserSettings.setDarkMode(false);
    }
    notifyListeners();
  }

  ThemeNotifier() {
    _theme = UserSettings.getDarkMode() ? darkTheme : standardTheme;
  }
}
