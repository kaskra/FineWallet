import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoorTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    return Container(
//      child: Center(
//        child: StreamBuilder<List<TransactionsWithCategory>>(
//          stream: Provider.of<AppDatabase>(context)
//              .transactionDao
//              .watchTransactionsOfCategory(1),
//          builder: (context, snapshot) {
//            if (snapshot.hasData) {
//              String t = "";
//              for (var tx in snapshot.data) {
//                t += tx.amount.toString() + " \t";
//                t += tx.subcategoryId.toString() + " \t";
//                t += tx.subcategoryName.toString() + " \t";
//                t += tx.categoryId.toStringAsFixed(2) + " \t";
//                t += tx.isExpense.toString() + " \t";
//                t += tx.recurringType.toString() + " \t";
//                t += tx.recurringUntil.toString() + " \t";
//                t += tx.date.toString() + " \t";
//                t += tx.isRecurring.toString() + "\n";
//              }
//
//              return Text(t);
//            }
//            return SizedBox();
//          },
//        ),
//      ),
//    );

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
