import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/budget_notifier.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpectedSavingsView extends StatelessWidget {
  final TextStyle textStyle;

  const ExpectedSavingsView({Key key, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchMonthlyIncome(DateTime.now()),
      builder: (context, snapshot) {
        double max = snapshot.hasData ? snapshot.data : 0;
        return Text(
          " ${(max - (Provider.of<BudgetNotifier>(context)?.budget ?? 0)).toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).currency}",
          style: textStyle,
        );
      },
    );
  }
}
