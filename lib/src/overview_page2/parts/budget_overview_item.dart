import 'package:FineWallet/data/providers/navigation_notifier.dart';
import 'package:FineWallet/src/widgets/views/daily_budget.dart';
import 'package:FineWallet/src/widgets/views/monthly_budget.dart';
import 'package:FineWallet/src/widgets/views/savings.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
              child: child,
            ),
          ),
          Text(
            footerText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
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
              _buildRowItem(
                context,
                child: DailyBudgetView(
                  textStyle:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                footerText: "Today",
              ),
              _buildRowItem(
                context,
                child: MonthlyBudgetView(
                  textStyle:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                footerText: getMonthName(DateTime.now().month).toString(),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildRowItem(
                  context,
                  child: SavingsView(
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  footerText: "Saved amount",
                ),
              ],
            ),
          ),
          _buildNavigationButton(context)
        ],
      ),
    );
  }

  MaterialButton _buildNavigationButton(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(),
      onPressed: () {
        Provider.of<NavigationNotifier>(context).setPage(0);
      },
      child: Text(
        "Change Available Budget",
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      minWidth: MediaQuery.of(context).size.width * 0.9,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
