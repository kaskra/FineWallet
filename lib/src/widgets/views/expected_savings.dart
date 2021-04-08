import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/budget_notifier.dart';
import 'package:FineWallet/src/widgets/formatted_strings.dart';
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
          .watchMonthlyIncome(today()),
      builder: (context, AsyncSnapshot<double> snapshot) {
        final double max = snapshot.hasData ? snapshot.data : 0;
        final value = max -
            (Provider.of<BudgetNotifier>(context)
                    ?.getBudget(BudgetFlag.monthly) ??
                0);
        return AmountString(
          value,
          textStyle: textStyle,
        );
      },
    );
  }
}
