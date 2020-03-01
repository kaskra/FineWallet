import 'package:FineWallet/data/moor_database.dart';
import 'package:moor/moor.dart';

part 'currency_dao.g.dart';

@UseDao(tables: [Currencies])
class CurrencyDao extends DatabaseAccessor<AppDatabase>
    with _$CurrencyDaoMixin {
  final AppDatabase db;

  CurrencyDao(this.db) : super(db);

  Future<List<Currency>> getAllCurrencies() => select(currencies).get();

  Future insertCurrency(Insertable<Currency> currency) =>
      into(currencies).insert(currency);

  Future updateCurrency(Insertable<Currency> currency) =>
      update(currencies).replace(currency);

  Future deleteCurrency(Insertable<Currency> currency) =>
      delete(currencies).delete(currency);

  Future<Currency> getCurrencyById(int id) =>
      (select(currencies)..where((c) => c.id.equals(id))).getSingle();
}
