import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/providers/navigation_notifier.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/overview_page/parts/monthly_expense_item.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/row_item.dart';
import 'package:FineWallet/src/widgets/views/daily_budget.dart';
import 'package:FineWallet/src/widgets/views/monthly_budget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetOverviewItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedCard(
      color: Theme.of(context).cardColor,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RowItem(
                footerText: LocaleKeys.today.tr(),
                child: const DailyBudgetView(
                  textStyle:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),
              RowItem(
                footerText: today().getMonthName(),
                child: const MonthlyBudgetView(
                  textStyle:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
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
                    LocaleKeys.budget_overview_used_budget.tr(),
                    style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
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
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () {
          Provider.of<NavigationNotifier>(context, listen: false).setPage(0);
        },
        child: Text(LocaleKeys.budget_overview_change_avail_budget.tr()),
      ),
    );
  }
}
