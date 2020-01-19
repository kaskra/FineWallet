import 'package:FineWallet/src/widgets/views/daily_budget.dart';
import 'package:FineWallet/src/widgets/views/monthly_budget.dart';
import 'package:FineWallet/src/widgets/views/savings.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';

class BudgetOverviewItem extends StatelessWidget {
  /// Builds the child widget into a container with a set padding.
  Widget _buildRowItem(BuildContext context,
      {@required Widget child, @required footerText}) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: child,
            ),
          ),
          Text(
            footerText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonth(BuildContext context) {
    return _buildRowItem(
      context,
      child: MonthlyBudgetView(
        textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      ),
      footerText: getMonthName(DateTime.now().month).toString(),
    );
  }

  Widget _buildToday(BuildContext context) {
    return _buildRowItem(
      context,
      child: DailyBudgetView(
        textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      ),
      footerText: "Today",
    );
  }

  Widget _buildSavings(BuildContext context) {
    return _buildRowItem(
      context,
      child: SavingsView(
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      footerText: "Saved amount",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildToday(context),
              _buildMonth(context),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildSavings(context),
              ],
            ),
          )
        ],
      ),
    );
  }
}
