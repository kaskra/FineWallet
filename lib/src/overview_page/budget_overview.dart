/*
 * Project: FineWallet
 * Last Modified: Sunday, 22nd September 2019 6:39:50 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/models/transaction_model.dart';
import 'package:FineWallet/core/resources/blocs/transaction_bloc.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/timeline.dart';
import 'package:FineWallet/src/widgets/timestamp.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
            Text(
              "130€", // TODO add bloc
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 26),
            ),
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

class WeekOverview2 extends StatelessWidget {
  const WeekOverview2(this.context, {Key key}) : super(key: key);

  final BuildContext context;

  Widget _buildDay(int day, double budget) {
    bool isToday = day == DateTime.now().weekday;

    return Container(
      padding: EdgeInsets.only(top: 6.0, bottom: 6.0, left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildDayName(isToday, day),
          _buildAmountString(budget, isToday),
        ],
      ),
    );
  }

  Widget _buildAmountString(double budget, bool isToday) {
    return Text(
      "${budget > 0 ? "-" : ""}${budget.toStringAsFixed(2)}€",
      maxLines: 1,
      style: TextStyle(
        fontSize: isToday ? 18 : 14,
        color: isToday
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).textTheme.body1.color,
        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildDayName(bool isToday, int day) {
    var formatter = new DateFormat('dd.MM.yy');
    String today = formatter.format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          isToday ? "TODAY" : getDayName(day),
          maxLines: 1,
          style: TextStyle(
            color: isToday
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).textTheme.body1.color,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            fontSize: isToday ? 16 : 14,
          ),
        ),
        isToday
            ? new Timestamp(
                color: Theme.of(context).primaryColor, size: 12, today: today)
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpandToWidth(
      child: DecoratedCard(
        borderWidth: 0,
        borderRadius: BorderRadius.circular(10),
        child: Consumer<TransactionBloc>(
          builder: (_, bloc, child) {
            bloc.getLastWeekTransactions();
            return StreamBuilder(
              stream: bloc.lastWeekTransactions,
              builder: (context,
                  AsyncSnapshot<List<SumOfTransactionModel>> snapshot) {
                if (snapshot.hasData) {
                  return Timeline(
                    color: Colors.grey,
                    selectionColor: Theme.of(context).primaryColor,
                    items: <Widget>[
                      for (SumOfTransactionModel m in snapshot.data)
                        _buildDay(m.date, m.amount.toDouble())
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}


