/*
 * Project: FineWallet
 * Last Modified: Tuesday, 24th September 2019 12:31:56 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/datatypes/tuple.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/src/widgets/timeline.dart';
import 'package:FineWallet/src/widgets/timestamp.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeekOverviewTimeline extends StatelessWidget {
  const WeekOverviewTimeline({Key key, this.context}) : super(key: key);

  final BuildContext context;

  Widget _buildDay(int day, double budget, DateTime date) {
    bool isToday = day == DateTime.now().weekday;

    TextStyle textStyle = TextStyle(
      color: isToday
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.onSecondary,
      fontSize: isToday ? 20 : 16,
      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
    );

    TextStyle numberTextStyle = TextStyle(
      color: isToday
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.onSecondary,
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

  /// Generates the days of the last seven days that are
  /// missing in the query result.
  ///
  /// Input
  /// -----
  /// [AsyncSnapshot] with the query result, which consists of the date
  /// in milliseconds since epoch and the sum of all expenses on that day.
  ///
  /// Return
  /// ------
  /// [List] of [Tuple3]s with the weekday, the sum of expenses and
  /// the [DateTime] of each day.
  List<Tuple3<int, double, DateTime>> _generateMissingDays(
      AsyncSnapshot<List<Tuple2<int, double>>> snapshot) {
    List<int> days = getLastWeekAsDates().map((t) => dayInMillis(t)).toList();

    return days.map((day) {
      var date = DateTime.fromMillisecondsSinceEpoch(day);
      int foundIndex = snapshot.data.indexWhere((t) => t.first == day);
      if (foundIndex != -1) {
        return Tuple3<int, double, DateTime>(
            date.weekday, snapshot.data[foundIndex].second, date);
      } else {
        return Tuple3<int, double, DateTime>(date.weekday, 0.0, date);
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchLastWeeksTransactions(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            heightFactor: 7,
            child: Text(
              "Could not load last weeks transactions! Error: ${snapshot.error.toString()}",
              style: TextStyle(color: Colors.black54),
            ),
          );
        }

        return !snapshot.hasData
            ? const Center(
                heightFactor: 7,
                child: CircularProgressIndicator(),
              )
            : Timeline(
                color: Colors.grey,
                selectionColor: Theme.of(context).colorScheme.secondary,
                items: <Widget>[
                  for (Tuple3<int, double, DateTime> tuple
                      in _generateMissingDays(snapshot))
                    _buildDay(tuple.first, tuple.second, tuple.third)
                ],
              );
      },
    );
  }
}
