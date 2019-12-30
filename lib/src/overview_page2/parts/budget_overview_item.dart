import 'package:FineWallet/src/widgets/information_row.dart';
import 'package:FineWallet/src/widgets/views/daily_budget.dart';
import 'package:FineWallet/src/widgets/views/monthly_budget.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';

class BudgetOverviewItem extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        children: <Widget>[
//          _buildDailyBudget(context),
//          VerticalBar(
//            width: 0.5,
//            color: Theme.of(context).colorScheme.onBackground,
//            height: 40,
//          ),
//          _buildMonthlyBudget(context),
//        ],
//      ),
//    );
//  }

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

  Widget _buildDailyBudgetRow(BuildContext context) {
    return InformationRow(
      padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, right: 8.0),
      text: Text(
        "Today",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      value: FittedBox(
        child: DailyBudgetView(
          textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }

  Widget _buildMonthlyBudgetRow(BuildContext context) {
    return InformationRow(
      padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, right: 8.0),
      text: Text(
        getMonthName(DateTime.now().month),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      value: FittedBox(
        child: MonthlyBudgetView(
          textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildDailyBudgetRow(context),
          _buildMonthlyBudgetRow(context),
        ],
      ),
    );
  }
}
