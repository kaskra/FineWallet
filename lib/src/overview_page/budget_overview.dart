/*
 * Project: FineWallet
 * Last Modified: Sunday, 22nd September 2019 6:39:50 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/resources/blocs/month_bloc.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetOverview extends StatelessWidget {
  const BudgetOverview({Key key}) : super(key: key);

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
            _buildAmountText(context),
            Text(
              "Available budget",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary, fontSize: 13),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAmountText(BuildContext context) {
    return Consumer<MonthBloc>(
      builder: (_, bloc, __) {
        bloc.getMonthlyBudget();
        bloc.getSavings();
        return StreamBuilder<double>(
          stream: bloc.monthlyBudget,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return StreamBuilder<double>(
                  stream: bloc.savings,
                  builder: (context, snapshot2) {
                    if (snapshot2.hasData) {
                      return Text(
                        "${(snapshot.data + snapshot2.data).toStringAsFixed(2)}€",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 26),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  });
            } else {
              return CircularProgressIndicator();
            }
          },
        );
      },
    );
  }
}

class DayOverview2 extends StatelessWidget {
  const DayOverview2({Key key}) : super(key: key);

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
