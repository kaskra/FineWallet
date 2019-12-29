/*
 * Project: FineWallet
 * Last Modified: Sunday, 22nd September 2019 6:39:50 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:FineWallet/src/widgets/vertical_bar.dart';
import 'package:FineWallet/src/widgets/views/daily_budget.dart';
import 'package:FineWallet/src/widgets/views/monthly_budget.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';

class BudgetOverview extends StatelessWidget {
  const BudgetOverview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandToWidth(
      child: DecoratedCard(
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildDailyBudget(context),
                _buildVerticalDivider(context),
                _buildMonthlyBudget(context),
              ],
            ),
            Divider(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            Text(
              "Remaining budget",
              style: TextStyle(fontSize: 13),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider(BuildContext context) {
    return VerticalBar(
      color: Theme.of(context).colorScheme.onPrimary,
      height: 50,
      width: 0.3,
      horizontalMargin: 10,
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
            style: TextStyle(fontSize: 12),
          ),
          FittedBox(
            child: MonthlyBudgetView(
              textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 26),
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
            style: TextStyle(fontSize: 12),
          ),
          FittedBox(
              child: DailyBudgetView(
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          )),
        ],
      ),
    );
  }
}
