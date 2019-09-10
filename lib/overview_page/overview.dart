/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:17:51 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/overview_page/day_overview.dart';
import 'package:FineWallet/overview_page/week_overview.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[DayOverview(context), WeekOverview(context)],
        ),
      ),
    );
  }
}
