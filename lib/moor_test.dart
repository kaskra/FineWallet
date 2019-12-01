import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoorTestPage extends StatefulWidget {
  @override
  _MoorTestPageState createState() => _MoorTestPageState();
}

class _MoorTestPageState extends State<MoorTestPage> {
  bool isExpense = false;
  int day = 1575115200000;

  @override
  Widget build(BuildContext context) {
    Transaction tx = Transaction(
      id: null,
      amount: 300,
      subcategoryId: 1,
      monthId: 1,
      date: dayInMillis(DateTime.now()),
      isExpense: false,
      isRecurring: true,
      recurringType: 1,
      recurringUntil: dayInMillis(DateTime.now().add(Duration(days: 7))),
    );

//    Provider.of<AppDatabase>(context).transactionDao.insertTransaction(tx);

//    Provider.of<AppDatabase>(context).transactionDao.deleteTransactionById(26);

    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            StreamBuilder<List<TransactionsWithCategory>>(
              stream: Provider.of<AppDatabase>(context)
                  .transactionDao
                  .watchTransactionsWithFilter(TransactionFilterSettings(
                    expenses: isExpense,
                    before: day,
                  )),
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
            FlatButton(
              child: Text("Switch between income and expenses!"),
              onPressed: () {
                setState(() {
                  isExpense = !isExpense;
                });
              },
            ),
            FlatButton(
              child: Text("Increase day!"),
              onPressed: () {
                setState(() {
                  day += 86400000;
                });
              },
            )
          ],
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
