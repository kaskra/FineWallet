/*
 * Project: FineWallet
 * Last Modified: Tuesday, 24th September 2019 12:31:30 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/resources/blocs/overview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyBudgetWidget extends StatelessWidget {
  const MonthlyBudgetWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OverviewBloc>(
      builder: (context, bloc, child) {
        bloc.getMonthlyBudget();
        return StreamBuilder<double>(
          stream: bloc.monthlyBudget,
          initialData: 0.0,
          builder: (context, snapshot) {
            return Text(
              "${snapshot.data.toStringAsFixed(2)}€",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 26),
            );
          },
        );
      },
    );
  }
}
