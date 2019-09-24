/*
 * Project: FineWallet
 * Last Modified: Tuesday, 24th September 2019 12:31:56 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/models/transaction_model.dart';
import 'package:FineWallet/src/base_view.dart';
import 'package:FineWallet/src/overview_page/week_overview_model.dart';
import 'package:FineWallet/src/widgets/timeline.dart';
import 'package:FineWallet/src/widgets/timestamp.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekOverviewView extends StatelessWidget {
  const WeekOverviewView({Key key, this.context}) : super(key: key);

  final BuildContext context;

  Widget _buildDay(int day, double budget, DateTime date) {
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

    return InkWell(
      borderRadius: BorderRadius.circular(CARD_RADIUS),
      onTap: () {
        print("Go to ${date.day}.${date.month}.${date.year}!");
      },
      child: Container(
        padding: EdgeInsets.only(top: 6.0, bottom: 6.0, left: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildDayName(day, isToday, textStyle),
            _buildAmountString(budget, numberTextStyle),
          ],
        ),
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
    return BaseWidget<WeekOverviewModel>(
      model: WeekOverviewModel(),
      onModelReady: (model) => model.updateExpenseList(),
      builder: (_, model, __) {
        return model.busy
            ? const CircularProgressIndicator()
            : Timeline(
                color: Colors.grey,
                selectionColor: Theme.of(context).colorScheme.secondary,
                items: <Widget>[
                  for (SumOfTransactionModel m in model.expenses)
                    _buildDay(m.weekday, m.amount.toDouble(), m.date)
                ],
              );
      },
    );
  }
}
