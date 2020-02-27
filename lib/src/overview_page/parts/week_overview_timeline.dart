/*
 * Project: FineWallet
 * Last Modified: Tuesday, 24th September 2019 12:31:56 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/datatypes/tuple.dart';
import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/src/history_page/history_page.dart';
import 'package:FineWallet/src/widgets/standalone/timeline.dart';
import 'package:FineWallet/src/widgets/standalone/timestamp.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeekOverviewTimeline extends StatelessWidget {
  const WeekOverviewTimeline(
      {Key key, @required this.context, this.fontSize = 16})
      : super(key: key);

  final BuildContext context;
  final double fontSize;

  Widget _buildDay(double budget, DateTime date) {
    final isToday = date.weekday == today().weekday;

    final textStyle = TextStyle(
      color: isToday ? Theme.of(context).colorScheme.secondary : null,
      fontSize: isToday ? (fontSize + 4) : fontSize,
      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
    );

    final numberTextStyle = TextStyle(
      color: isToday ? Theme.of(context).colorScheme.secondary : null,
      fontSize: isToday ? (fontSize + 4) : fontSize,
      fontWeight: FontWeight.bold,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(cardRadius),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => _historyWithScaffold(date, context)));
      },
      child: Container(
        padding: const EdgeInsets.only(top: 6.0, bottom: 6.0, left: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildDayName(date, isToday, textStyle),
            _buildAmountString(budget, numberTextStyle),
          ],
        ),
      ),
    );
  }

  Scaffold _historyWithScaffold(DateTime date, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expenses on ${date.day}.${date.month}.${date.year}"),
      ),
      body: HistoryPage(
        onChangeSelectionMode: (s) {},
        filterSettings: TransactionFilterSettings(day: date, expenses: true),
      ),
    );
  }

  Widget _buildAmountString(double budget, TextStyle textStyle) {
    return Text(
      "${budget > 0 ? "-" : ""}${budget.toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).currency}",
      maxLines: 1,
      style: textStyle,
    );
  }

  Widget _buildDayName(DateTime date, bool isToday, TextStyle textStyle) {
    final formatter = DateFormat('E, dd.MM.yy');
    final todayString = formatter.format(today());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(isToday ? "TODAY" : date.getDayName(),
            maxLines: 1, style: textStyle),
        if (isToday)
          Timestamp(color: textStyle.color, size: 12, today: todayString)
        else
          const SizedBox(),
      ],
    );
  }

  /// Generates the days of the last seven days that are
  /// missing in the query result.
  ///
  /// Input
  /// -----
  /// [AsyncSnapshot] with the query result, which consists of the date
  /// and the sum of all expenses on that day.
  ///
  /// Return
  /// ------
  /// [List] of [Tuple3]s with the weekday, the sum of expenses and
  /// the [DateTime] of each day.
  List<Tuple2<double, DateTime>> _generateMissingDays(
      AsyncSnapshot<List<Tuple2<DateTime, double>>> snapshot) {
    final List<DateTime> days = getLastWeekAsDates();

    return days.map((day) {
      final foundIndex =
          snapshot.data.indexWhere((t) => t.first.isAtSameMomentAs(day));
      if (foundIndex != -1) {
        return Tuple2<double, DateTime>(snapshot.data[foundIndex].second, day);
      } else {
        return Tuple2<double, DateTime>(0.0, day);
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchLastWeeksTransactions(),
      builder:
          (context, AsyncSnapshot<List<Tuple2<DateTime, double>>> snapshot) {
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
                  for (Tuple2<double, DateTime> tuple
                      in _generateMissingDays(snapshot))
                    _buildDay(tuple.first, tuple.second)
                ],
              );
      },
    );
  }
}
