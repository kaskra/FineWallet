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

    TextStyle textStyle = TextStyle(
      color: isToday
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.onSurface,
      fontSize: isToday ? 20 : 16,
      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
    );

    TextStyle numberTextStyle = TextStyle(
      color: isToday
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.onSurface,
      fontSize: isToday ? 20 : 16,
      fontWeight: FontWeight.bold,
    );

    return Container(
      padding: EdgeInsets.only(top: 6.0, bottom: 6.0, left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildDayName(day, isToday, textStyle),
          _buildAmountString(budget, numberTextStyle),
        ],
      ),
    );
  }

  Widget _buildAmountString(double budget, TextStyle textStyle) {
    return Text(
      "${budget > 0 ? "-" : ""}${budget.toStringAsFixed(2)}€",
      maxLines: 1,
      style: textStyle,
    );
  }

  Widget _buildDayName(int day, bool isToday, TextStyle textStyle) {
    var formatter = new DateFormat('E, dd.MM.yy');
    String today = formatter.format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(isToday ? "TODAY" : getDayName(day),
            maxLines: 1, style: textStyle),
        isToday
            ? new Timestamp(color: textStyle.color, size: 12, today: today)
            : const SizedBox(),
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
                    selectionColor: Theme.of(context).colorScheme.secondary,
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
