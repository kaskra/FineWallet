/*
 * Project: FineWallet
 * Last Modified: Tuesday, 24th September 2019 12:31:30 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/src/base_view.dart';
import 'package:FineWallet/src/overview_page/monthly_budget_model.dart';
import 'package:flutter/material.dart';

class MonthlyBudgetView extends StatelessWidget {
  const MonthlyBudgetView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<MonthlyBudgetViewModel>(
      model: MonthlyBudgetViewModel(),
      onModelReady: (model) => model.updateBudget(),
      builder: (_, model, __) {
        return Text(
          model.busy ? "0.00€" : "${model.budget.toStringAsFixed(2)}€",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 26),
        );
      },
    );
  }
}
