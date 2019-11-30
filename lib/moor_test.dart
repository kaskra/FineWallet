import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoorTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Transaction tx = Transaction(
        id: null,
        amount: 150,
        subcategoryId: 1,
        monthId: 1,
        date: dayInMillis(DateTime.now()),
        isExpense: true,
        isRecurring: true,
        recurringType: 4,
        recurringUntil: dayInMillis(DateTime.now().add(Duration(days: 32))));

//    Provider.of<AppDatabase>(context).transactionDao.insertTransaction(tx);

    return Container(
      child: Center(
        child: StreamBuilder<List<TransactionsWithCategory>>(
          stream: Provider.of<AppDatabase>(context)
              .transactionDao
              .watchTransactionsOfCategory(1),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String t = "";
              for (var tx in snapshot.data) {
                t += tx.id.toString() + " \t";
                t += tx.amount.toString() + " \t";
                t += tx.subcategoryId.toString() + " \t";
                t += tx.subcategoryName.toString() + " \t";
                t += tx.categoryId.toStringAsFixed(2) + " \t";
                t += tx.isExpense.toString() + " \t";
                t += tx.date.toString() + " \t";
                t += tx.isRecurring.toString() + "\n";
                t += tx.recurringUntil.toString() + " \t";
                t += tx.originalId.toString() + "\n";
              }

              return Text(t);
            }
            return SizedBox();
          },
        ),
      ),
    );

    return Center(
      child: StreamBuilder(
        stream: Provider.of<AppDatabase>(context)
            .transactionDao
            .watchTotalSavings(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.toString());
          }
          return SizedBox();
        },
      ),
    );
  }
}
