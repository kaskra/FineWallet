import 'package:FineWallet/data/moor_database.dart';
import 'package:moor/moor.dart';

part 'currency_dao.g.dart';

@UseDao(
  tables: [
    Currencies,
    UserProfiles,
  ],
  include: {
    "moor_files/currency_queries.moor",
  },
)
class CurrencyDao extends DatabaseAccessor<AppDatabase>
    with _$CurrencyDaoMixin {
  final AppDatabase db;

  CurrencyDao(this.db) : super(db);

  Future<List<Currency>> getAllCurrencies() => _allCurrencies().get();

  Stream<List<Currency>> watchAllCurrencies() => _allCurrencies().watch();

  Future<int> insertCurrency(Insertable<Currency> currency) =>
      into(currencies).insert(currency);

  Future<bool> updateCurrency(Insertable<Currency> currency) =>
      update(currencies).replace(currency);

  Future<int> deleteCurrency(Insertable<Currency> currency) =>
      delete(currencies).delete(currency);

  Future<Currency> getCurrencyById(int id) =>
      _currencyById(id).getSingleOrNull();

  Future<Currency> getUserCurrency() => _userCurrency().getSingleOrNull();

  Stream<Currency> watchUserCurrency() => _userCurrency().watchSingleOrNull();

  /// Updates the currencies table with new exchange rates.
  ///
  /// Input
  /// -----
  /// - [Map] of rates that consist of the currency abbreviation
  /// and the current exchange rate.
  /// - list of [Currency] of all available and saved currencies.
  ///
  Future updateExchangeRates(
      Map<String, double> rates, List<Currency> allCurrencies) async {
    if (rates.isEmpty) return;

    await batch((b) {
      for (final curr in allCurrencies) {
        if (rates.containsKey(curr.abbrev)) {
          b.replace(
              currencies, curr.copyWith(exchangeRate: rates[curr.abbrev]));
        }
      }
    });
  }
}
