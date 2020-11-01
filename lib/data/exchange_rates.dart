import 'dart:convert';

import 'package:FineWallet/logger.dart';
import 'package:http/http.dart' as http;

Future<ExchangeRates> fetchExchangeRates(
    String base, List<String> currencies) async {
  final nonBaseCurrencies = currencies.where((c) => c != base).toList();
  final url = "https://api.exchangeratesapi.io/latest?base=$base";

  logMsg("Fetch exchange rates from $url...");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return ExchangeRates.fromJson(
        json.decode(response.body) as Map<String, dynamic>, nonBaseCurrencies);
  } else {
    throw Exception("Failed to load exchange rates!");
  }
}

class ExchangeRates {
  final String base;
  final Map<String, double> rates;

  ExchangeRates({this.base, this.rates});

  factory ExchangeRates.fromJson(
      Map<String, dynamic> json, List<String> currencies) {
    final rs = <String, double>{};

    for (final curr in currencies) {
      final rate = double.tryParse(json['rates'][curr].toString());
      rs.putIfAbsent(curr, () => 1 / rate ?? 1.0);
    }
    rs.putIfAbsent(json['base'].toString(), () => 1.0);
    return ExchangeRates(
      base: json['base'].toString(),
      rates: rs,
    );
  }

  @override
  String toString() {
    return 'ExchangeRates{base: $base, rates: $rates}';
  }
}
