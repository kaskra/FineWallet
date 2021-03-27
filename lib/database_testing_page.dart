import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DatabaseTestingPage extends StatefulWidget {
  const DatabaseTestingPage({Key key}) : super(key: key);

  @override
  _DatabaseTestingPageState createState() => _DatabaseTestingPageState();
}

class _DatabaseTestingPageState extends State<DatabaseTestingPage> {
  void transactionsResultToString(TransactionsResult tx) {
    print('TransactionsResult{id: ${tx.id},'
        ' amount: ${tx.amount}, '
        'originalAmount: ${tx.originalAmount}, '
        'exchangeRate: ${tx.exchangeRate}, '
        'isExpense: ${tx.isExpense}, '
        'date: ${tx.date}, '
        'label: ${tx.label}, '
        'subcategoryId: ${tx.subcategoryId}, '
        'monthId: ${tx.monthId}, '
        'currencyId: ${tx.currencyId}, '
        'recurrenceType: ${tx.recurrenceType}, '
        'until: ${tx.until}, '
        'recurrenceName: ${tx.recurrenceName}}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Database Testing'),
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(backgroundColor: Colors.white))),
          child: Center(
            child: Column(
              children: [
                _buildEnterTransactionsButton(),
                _buildEnterRecurringTransactionsButton(),
                _buildReadTransactionsButton(),
              ],
            ),
          ),
        ));
  }

  Widget _buildEnterTransactionsButton() {
    return TextButton(
        onPressed: () {
          final txs = [
            BaseTransaction(
              id: null,
              amount: 100,
              originalAmount: 100,
              exchangeRate: null,
              isExpense: false,
              date: DateTime.now(),
              label: "Gehalt",
              subcategoryId: 66,
              monthId: null,
              currencyId: 2,
              recurrenceType: 1,
            ),
            BaseTransaction(
              id: null,
              amount: 42,
              originalAmount: 42,
              exchangeRate: null,
              isExpense: true,
              date: DateTime.now(),
              label: "Kaffee",
              subcategoryId: 17,
              monthId: null,
              currencyId: 2,
              recurrenceType: 1,
            ),
          ];
          for (final t in txs) {
            Provider.of<AppDatabase>(context, listen: false)
                .transactionDao
                .insertTransaction(t);
          }
        },
        child: const Text("Add txs"));
  }

  Widget _buildReadTransactionsButton() {
    return TextButton(
      onPressed: () async {
        final txs = await Provider.of<AppDatabase>(context, listen: false)
            .transactionDao
            .getAllTransactions();

        for (final t in txs) {
          transactionsResultToString(t);
        }
        print(txs.length);
      },
      child: const Text("Read txs"),
    );
  }

  Widget _buildEnterRecurringTransactionsButton() {
    return TextButton(
        onPressed: () {
          final daily = BaseTransaction(
            id: null,
            amount: 10,
            originalAmount: 10,
            exchangeRate: null,
            isExpense: true,
            date: DateTime.now(),
            label: "Mittagessen",
            subcategoryId: 12,
            monthId: null,
            currencyId: 2,
            recurrenceType: 2,
            until: DateTime.now().add(const Duration(days: 8)),
          );
          Provider.of<AppDatabase>(context, listen: false)
              .transactionDao
              .insertTransaction(daily);

          final weekly = BaseTransaction(
            id: null,
            amount: 21,
            originalAmount: 21,
            exchangeRate: null,
            isExpense: true,
            date: DateTime.now(),
            label: "Paaartyy",
            subcategoryId: 18,
            monthId: null,
            currencyId: 2,
            recurrenceType: 3,
            until: DateTime.now().add(const Duration(days: 15)),
          );
          Provider.of<AppDatabase>(context, listen: false)
              .transactionDao
              .insertTransaction(weekly);

          final monthly = BaseTransaction(
            id: null,
            amount: 4.5,
            originalAmount: 4.5,
            exchangeRate: null,
            isExpense: true,
            date: DateTime.now(),
            label: "Netflix",
            subcategoryId: 18,
            monthId: null,
            currencyId: 2,
            recurrenceType: 4,
            until: DateTime.now().add(const Duration(days: 70)),
          );
          Provider.of<AppDatabase>(context, listen: false)
              .transactionDao
              .insertTransaction(monthly);

          final yearly = BaseTransaction(
            id: null,
            amount: 69,
            originalAmount: 69,
            exchangeRate: null,
            isExpense: true,
            date: DateTime.now(),
            label: "Amazon",
            subcategoryId: 18,
            monthId: null,
            currencyId: 2,
            recurrenceType: 5,
            until: DateTime.now().add(const Duration(days: 400)),
          );
          Provider.of<AppDatabase>(context, listen: false)
              .transactionDao
              .insertTransaction(yearly);
        },
        child: const Text("Add recurring txs"));
  }
}
