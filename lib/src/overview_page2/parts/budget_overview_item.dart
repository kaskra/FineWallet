import 'package:FineWallet/src/widgets/vertical_bar.dart';
import 'package:FineWallet/src/widgets/views/daily_budget.dart';
import 'package:FineWallet/src/widgets/views/monthly_budget.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';

class BudgetOverviewItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildDailyBudget(context),
          VerticalBar(
            width: 0.5,
            color: Theme.of(context).colorScheme.onBackground,
            height: 40,
          ),
          _buildMonthlyBudget(context),
        ],
      ),
    );
  }

  Widget _buildMonthlyBudget(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            getMonthName(DateTime.now().month).toUpperCase().toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          FittedBox(
            child: MonthlyBudgetView(
              textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyBudget(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "TODAY",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          FittedBox(
              child: DailyBudgetView(
            textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          )),
        ],
      ),
    );
  }
}
