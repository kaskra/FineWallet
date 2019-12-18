import 'package:FineWallet/data/user_settings.dart';
import 'package:flutter/material.dart';

class LocalizationNotifier extends ChangeNotifier {
  String _languageCode = "en";
  String _currencySymbol = "\$";

  String get language => _languageCode;

  String get currency => _currencySymbol;

  setLanguageCode(int c) async {
    UserSettings.setLanguage(c);
    _languageCode = mapIdToLanguage(c);
    notifyListeners();
  }

  setCurrencySymbol(int c) {
    UserSettings.setCurrency(c);
    _currencySymbol = mapIdToCurrency(c);
    notifyListeners();
  }

  LocalizationNotifier() {
    _currencySymbol = mapIdToCurrency(UserSettings.getCurrency());
    _languageCode = mapIdToLanguage(UserSettings.getLanguage());
  }
}

String mapIdToCurrency(int id) {
  if (id == 1) {
    return "\$";
  } else if (id == 2) {
    return "€";
  }
  return "\$";
}

String mapIdToLanguage(int id) {
  if (id == 1) {
    return "en";
  } else if (id == 2) {
    return "de";
  }
  return "en";
}
