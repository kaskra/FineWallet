import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/src/monthly_reports_page/parts/used_budget_bar.dart';
import 'package:FineWallet/src/widgets/row_item.dart';
import 'package:FineWallet/src/widgets/standalone/result_arrow.dart';
import 'package:FineWallet/src/widgets/structure/structure_space.dart';
import 'package:FineWallet/src/widgets/structure/structure_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverallDetail extends StatelessWidget {
  final MonthWithDetails month;

  const OverallDetail({Key key, @required this.month}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final savings = month.income - month.expense;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const StructureTitle(
          text: "Overall",
        ),
        SmallStructureSpace(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: UsedBudgetBar(
            model: month,
            padding: const EdgeInsets.only(top: 0),
          ),
        ),
        StructureSpace(),
        Row(
          children: <Widget>[
            RowItem(
              amountPadding: const EdgeInsets.symmetric(vertical: 4),
              footerText: "Total Income",
              footerTextColor: Theme.of(context).colorScheme.onBackground,
              child: Text(
                "+${month.income.toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).currency}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.green),
              ),
            ),
            const ResultArrow(),
            RowItem(
              amountPadding: const EdgeInsets.symmetric(vertical: 4),
              footerText: "Total Expense",
              footerTextColor: Theme.of(context).colorScheme.onBackground,
              child: Text(
                "-${month.expense.toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).currency}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.red),
              ),
            ),
          ],
        ),
        StructureSpace(),
        Row(
          children: <Widget>[
            RowItem(
              amountPadding: const EdgeInsets.symmetric(vertical: 4),
              footerText: "Savings",
              footerTextColor: Theme.of(context).colorScheme.onBackground,
              child: Text(
                "${savings > 0 ? "+" : ""}${savings.toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).currency}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: savings > 0 ? Colors.green : Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
