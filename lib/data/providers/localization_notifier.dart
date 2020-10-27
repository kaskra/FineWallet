import 'package:flutter/material.dart';

class LocalizationNotifier extends ChangeNotifier {
  String _currencySymbol = "\$";

  String get userCurrency => _currencySymbol;

  Future setUserCurrencySymbol(String symbol) async {
    _currencySymbol = symbol;
    notifyListeners();
  }
}
