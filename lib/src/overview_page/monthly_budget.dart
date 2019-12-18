/*
 * Project: FineWallet
 * Last Modified: Tuesday, 24th September 2019 12:31:30 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyBudgetWidget extends StatelessWidget {
  const MonthlyBudgetWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchMonthlyBudget(DateTime.now()),
      initialData: 0.0,
      builder: (context, snapshot) {
        return Text(
          "${snapshot.data.toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).currency}",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 26),
        );
      },
    );
  }
}
