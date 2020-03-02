/*
 * Project: FineWallet
 * Last Modified: Tuesday, 24th September 2019 12:31:30 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/src/widgets/formatted_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyBudgetView extends StatelessWidget {
  final TextStyle textStyle;

  const MonthlyBudgetView({Key key, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchMonthlyBudget(today()),
      initialData: 0.0,
      builder: (context, snapshot) {
        return AmountString(
          snapshot.data,
          textStyle: textStyle,
        );
      },
    );
  }
}
