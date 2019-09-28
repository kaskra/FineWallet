/*
 * Project: FineWallet
 * Last Modified: Saturday, 28th September 2019 11:08:55 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/resources/blocs/overview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyBudgetWidget extends StatelessWidget {
  const DailyBudgetWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OverviewBloc>(
      builder: (context, bloc, child) {
        bloc.getDailyBudget();
        return StreamBuilder<double>(
          stream: bloc.dailyBudget,
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
