/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:17:51 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/src/overview_page/budget_overview.dart';
import 'package:FineWallet/src/overview_page/placeholder_box.dart';
import 'package:FineWallet/src/overview_page/week_overview.dart';
import 'package:flutter/material.dart';

import 'last_transaction.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: ListView(
          children: <Widget>[
            BudgetOverview(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                LastTransaction(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: PlaceholderOverview(),
                  ),
                ),
              ],
            ),
            WeekOverview(),
          ],
        ),
      ),
    );
  }
}
