import 'package:FineWallet/logger.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

Future<ExchangeRates> fetchExchangeRates(
    String base, List<String> currencies) async {
  final client = http.Client();
  final Map<String, num> retrievedQuoteData =
      await ECB.fx(base, currencies, client);

  return ExchangeRates.fromJson(base, retrievedQuoteData, currencies);
}

/// Returns exchange rates to a base,
/// rates given are "rate to base", so 100 USD * rate = 85 EUR.
class ExchangeRates {
  final String base;
  final Map<String, double> rates;

  ExchangeRates({this.base, this.rates});

  factory ExchangeRates.fromJson(
      String base, Map<String, num> json, List<String> currencies) {
    final rs = <String, double>{};

    for (final curr in currencies) {
      final key = "$base$curr";
      if (json.containsKey(key)) {
        var rate = json[key].toDouble();
        rate = double.parse((1 / rate ?? 1.0).toStringAsFixed(3));
        rs.putIfAbsent(curr, () => rate);
      }
    }

    rs.putIfAbsent(base, () => 1.0);

    return ExchangeRates(
      base: base,
      rates: rs,
    );
  }

  @override
  String toString() {
    return 'ExchangeRates{base: $base, rates: $rates}';
  }
}

// maybe add https://github.com/ismaelJimenez/forex/blob/master/lib/src/quote_providers/yahoo.dart
// https://github.com/ismaelJimenez/finance_quote/blob/master/lib/src/quote_providers/yahoo.dart

class ECBApiException implements Exception {
  final int statusCode;
  final String message;

  const ECBApiException({this.statusCode, this.message});
}

class ECB {
  static Future<Map<String, num>> fx(
      String base, List<String> quotes, http.Client client) async {
    final Map<String, num> results = <String, num>{};

    try {
      final Map<String, num> fxQuotes = await _getFxQuotes(client);

      // Search in the answer obtained the data corresponding to the symbols.
      // If requested symbol data is found add it to results.
      if (base == 'EUR') {
        fxQuotes.forEach((String key, num value) {
          if (quotes.contains(key)) {
            results[base + key] = value;
          }
        });
      } else {
        if (fxQuotes.containsKey(base)) {
          final num baseQuote = 1 / fxQuotes[base];

          if (quotes.contains('EUR')) {
            results['${base}EUR'] = baseQuote;
          }

          fxQuotes.forEach((String key, num value) {
            if (quotes.contains(key)) {
              results[base + key] = value * baseQuote;
            }
          });
        }
      }
    } on ECBApiException catch (e) {
      logMsg(
          'EcbApiException{base: $base, quotes: ${quotes.join(',')}, statusCode: ${e.statusCode}, message: ${e.message}}');
    }

    for (final String symbol in quotes) {
      if (!results.containsKey(base + symbol)) {
        logMsg('EcbApi: Symbol $symbol not found.');
      }
    }

    return results;
  }

  static Future<Map<String, num>> _getFxQuotes(http.Client client) async {
    const String quoteUrl =
        'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml';
    try {
      final uri = Uri.parse(quoteUrl);
      final http.Response quoteRes = await client.get(uri);
      if (quoteRes != null &&
          quoteRes.statusCode == 200 &&
          quoteRes.body != null) {
        return parseRawQuote(quoteRes.body);
      } else {
        throw ECBApiException(
            statusCode: quoteRes?.statusCode, message: 'Invalid response.');
      }
    } on http.ClientException {
      throw const ECBApiException(message: 'Connection failed.');
    }
  }

  static Map<String, num> parseRawQuote(String quoteResBody) {
    final Map<String, num> results = <String, num>{};

    try {
      final xml.XmlDocument document = xml.XmlDocument.parse(quoteResBody);

      final Iterable<xml.XmlElement> allNodes =
          document.findAllElements('Cube');

      for (final xml.XmlElement node in allNodes) {
        final String currency = node.getAttribute('currency');
        final String rate = node.getAttribute('rate');

        if (currency != null && rate != null) {
          results[currency] = num.parse(rate);
        }
      }
      return results;
    } catch (e) {
      throw const ECBApiException(
          statusCode: 200, message: 'Quote was not parseable.');
    }
  }
}
