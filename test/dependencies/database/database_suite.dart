import 'category_test.dart';
import 'currency_test.dart';
import 'months_test.dart';
import 'transactions_test.dart';

void runDatabaseTests() {
  testTransactions();
  testMonths();
  testCategory();
  testSubcategory();
  testCurrency();
}
