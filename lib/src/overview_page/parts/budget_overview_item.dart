import 'package:FineWallet/constants.dart';
import 'package:FineWallet/data/providers/navigation_notifier.dart';
import 'package:FineWallet/src/overview_page/parts/monthly_expense_item.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/row_item.dart';
import 'package:FineWallet/src/widgets/views/daily_budget.dart';
import 'package:FineWallet/src/widgets/views/monthly_budget.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetOverviewItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedCard(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RowItem(
                child: DailyBudgetView(
                  textStyle:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                footerText: "Today",
              ),
              RowItem(
                child: MonthlyBudgetView(
                  textStyle:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                footerText: getMonthName(DateTime.now().month).toString(),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Center(
              child: Column(
                children: <Widget>[
                  MonthlyExpenseItem(),
                  Text(
                    "Used Budget",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )
                ],
              ),
            ),
          ),
          _buildNavigationButton(context),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius)),
        onPressed: () {
          Provider.of<NavigationNotifier>(context, listen: false).setPage(0);
        },
        child: Text(
          "Change Available Budget",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        minWidth: MediaQuery.of(context).size.width * 0.9,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
