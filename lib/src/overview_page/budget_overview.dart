/*
 * Project: FineWallet
 * Last Modified: Sunday, 22nd September 2019 6:39:50 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/constants.dart';
import 'package:FineWallet/src/overview_page/daily_budget.dart';
import 'package:FineWallet/src/overview_page/monthly_budget.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:FineWallet/src/widgets/vertical_bar.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';

class BudgetOverview extends StatefulWidget {
  const BudgetOverview({Key key}) : super(key: key);

  @override
  _BudgetOverviewState createState() => _BudgetOverviewState();
}

class _BudgetOverviewState extends State<BudgetOverview> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandToWidth(
      child: DecoratedCard(
        color: Theme.of(context).colorScheme.primary,
        borderWidth: 0,
        borderRadius: BorderRadius.circular(CARD_RADIUS),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildDailyBudget(context),
                buildVerticalDivider(context),
                buildMonthlyBudget(context),
              ],
            ),
            Divider(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            Text(
              "Remaining budget",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary, fontSize: 13),
            )
          ],
        ),
      ),
    );
  }

  Widget buildVerticalDivider(BuildContext context) {
    return VerticalBar(
      color: Theme.of(context).colorScheme.onPrimary,
      height: 50,
      width: 0.3,
      horizontalMargin: 10,
    );
  }

  Widget buildMonthlyBudget(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            getMonthName(DateTime.now().month).toUpperCase().toString(),
            style: TextStyle(
                fontSize: 12, color: Theme.of(context).colorScheme.onPrimary),
          ),
          FittedBox(
            child: MonthlyBudgetWidget(),
          ),
        ],
      ),
    );
  }

  Widget buildDailyBudget(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "TODAY",
            style: TextStyle(
                fontSize: 12, color: Theme.of(context).colorScheme.onPrimary),
          ),
          FittedBox(child: DailyBudgetWidget()),
        ],
      ),
    );
  }
}

class LastTransaction extends StatelessWidget {
  const LastTransaction({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandToWidth(
      child: DecoratedCard(
        borderWidth: 0,
        borderRadius: BorderRadius.circular(10),
        child: const SizedBox(
          height: 50,
        ),
      ),
    );
  }
}
