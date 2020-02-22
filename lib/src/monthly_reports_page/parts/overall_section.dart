import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/src/overview_page2/parts/row_item.dart';
import 'package:FineWallet/src/statistics_page/used_budget_bar.dart';
import 'package:FineWallet/src/widgets/result_arrow.dart';
import 'package:FineWallet/src/widgets/structure/structure_space.dart';
import 'package:FineWallet/src/widgets/structure/structure_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverallDetail extends StatelessWidget {
  final MonthWithDetails month;

  const OverallDetail({Key key, @required this.month}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var savings = month.income - month.expense;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StructureTitle(
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
              child: Text(
                "+${month.income.toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).currency}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.green),
              ),
              amountPadding: const EdgeInsets.symmetric(vertical: 4),
              footerText: "Total Income",
              footerTextColor: Theme.of(context).colorScheme.onBackground,
            ),
            ResultArrow(),
            RowItem(
              child: Text(
                "-${month.expense.toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).currency}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.red),
              ),
              amountPadding: const EdgeInsets.symmetric(vertical: 4),
              footerText: "Total Expense",
              footerTextColor: Theme.of(context).colorScheme.onBackground,
            ),
          ],
        ),
        StructureSpace(),
        Row(
          children: <Widget>[
            RowItem(
              child: Text(
                "${savings > 0 ? "+" : ""}${savings.toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).currency}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: savings > 0 ? Colors.green : Colors.red),
              ),
              amountPadding: const EdgeInsets.symmetric(vertical: 4),
              footerText: "Savings",
              footerTextColor: Theme.of(context).colorScheme.onBackground,
            ),
          ],
        ),
      ],
    );
  }
}
