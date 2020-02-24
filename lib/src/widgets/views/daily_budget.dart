/*
 * Project: FineWallet
 * Last Modified: Saturday, 28th September 2019 11:08:55 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyBudgetView extends StatelessWidget {
  final TextStyle textStyle;

  const DailyBudgetView({Key key, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchDailyBudget(today()),
      initialData: 0.0,
      builder: (context, snapshot) {
        return Text(
          "${snapshot.hasData ? snapshot.data.toStringAsFixed(2) : "0.00"}${Provider.of<LocalizationNotifier>(context).currency}",
          style: textStyle,
        );
      },
    );
  }
}
