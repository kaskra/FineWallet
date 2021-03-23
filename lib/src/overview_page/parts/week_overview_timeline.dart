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
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/history_page/history_page.dart';
import 'package:FineWallet/src/widgets/formatted_strings.dart';
import 'package:FineWallet/src/widgets/standalone/timeline.dart';
import 'package:FineWallet/src/widgets/standalone/timestamp.dart';
import 'package:FineWallet/utils.dart';
import 'package:easy_localization/easy_localization.dart';
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
            AmountString(
              budget * -1,
              textStyle: numberTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  Scaffold _historyWithScaffold(DateTime date, BuildContext context) {
    final formatter = DateFormat.MMMd(context.locale.toLanguageTag());
    final todayString = formatter.format(date);

    return Scaffold(
      appBar: AppBar(
        title:
            Text(LocaleKeys.history_page_expenses_on.tr(args: [todayString])),
      ),
      body: HistoryPage(
        filterSettings: TransactionFilterSettings(day: date, expenses: true),
      ),
    );
  }

  Widget _buildDayName(DateTime date, bool isToday, TextStyle textStyle) {
    final formatter = DateFormat.MEd(context.locale.toLanguageTag());
    final todayString = formatter.format(today());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(isToday ? LocaleKeys.today.tr().toUpperCase() : date.getDayName(),
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
              LocaleKeys.overview_page_last_week_load_error.tr(),
              style: const TextStyle(color: Colors.black54),
            ),
          );
        }
        return !snapshot.hasData
            ? const Center(
                heightFactor: 7,
                child: CircularProgressIndicator(),
              )
            : Timeline(
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
