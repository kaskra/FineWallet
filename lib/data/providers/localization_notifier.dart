import 'package:FineWallet/data/user_settings.dart';
import 'package:flutter/material.dart';

class LocalizationNotifier extends ChangeNotifier {
  String _languageCode = "en";
  String _currencySymbol = "\$";

  String get language => _languageCode;

  String get currency => _currencySymbol;

  setLanguageCode(int c) async {
    UserSettings.setLanguage(c);
    if (c == 1) {
      _languageCode = "en";
    } else if (c == 2) {
      _languageCode = "de";
    }
    notifyListeners();
  }

  setCurrencySymbol(int c) {
    UserSettings.setCurrency(c);
    if (c == 1) {
      _currencySymbol = "\$";
    } else if (c == 2) {
      _currencySymbol = "€";
    }
    notifyListeners();
  }
}
