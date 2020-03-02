import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/budget_notifier.dart';
import 'package:FineWallet/src/widgets/formatted_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AvailableBudgetView extends StatelessWidget {
  final TextStyle textStyle;

  const AvailableBudgetView({Key key, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream:
          Provider.of<AppDatabase>(context).transactionDao.watchTotalSavings(),
      builder: (context, snapshot) {
        double maxBudget = snapshot.data ?? 0;
        maxBudget += Provider.of<BudgetNotifier>(context)?.budget ?? 0;
        return AmountString(maxBudget, textStyle: textStyle);
      },
    );
  }
}
