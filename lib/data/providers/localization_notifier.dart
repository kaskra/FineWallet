import 'package:FineWallet/data/user_settings.dart';
import 'package:flutter/material.dart';

class LocalizationNotifier extends ChangeNotifier {
  String _languageCode = "en";
  String _currencySymbol = "\$";

  String get language => _languageCode;

  String get userCurrency => _currencySymbol;

  Future setLanguageCode(int c) async {
    UserSettings.setLanguage(c);
    _languageCode = mapIdToLanguage(c);
    notifyListeners();
  }

  Future setUserCurrencySymbol(String symbol) async {
    _currencySymbol = symbol;
    notifyListeners();
  }

  LocalizationNotifier() {
    _languageCode = mapIdToLanguage(UserSettings.getLanguage());
  }
}

String mapIdToLanguage(int id) {
  if (id == 1) {
    return "en";
  } else if (id == 2) {
    return "de";
  }
  return "en";
}
