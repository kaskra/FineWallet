/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:20:08 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/datatypes/chart_data.dart';
import 'package:FineWallet/core/datatypes/tuple.dart';
import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpendingPredictionChart extends StatefulWidget {
  const SpendingPredictionChart({this.monthlyBudget = 0});

  final double monthlyBudget;

  @override
  _SpendingPredictionChartState createState() =>
      _SpendingPredictionChartState();
}

class _SpendingPredictionChartState extends State<SpendingPredictionChart> {
  DateTime _todayDate;

  @override
  void initState() {
    super.initState();
    setState(() {
      _todayDate = today();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _buildChart(),
    );
  }

  Widget _buildChart() {
    return StreamBuilder(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchExpensesPerDayInMonth(today()),
      builder:
          (context, AsyncSnapshot<List<Tuple2<DateTime, double>>> snapshot) {
        if (snapshot.hasData) {
          return PredictionDateChart.withTransactions(
              _calcDateTimeDataPoints(snapshot), widget.monthlyBudget ?? 0.0);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  List<PredictionPointDate> _calcDateTimeDataPoints(
      AsyncSnapshot<List<Tuple2<DateTime, double>>> snapshot) {
    // All days of month as date
    final List<DateTime> days = getListOfMonthDays(_todayDate);

    // Calc the step function by using all expenses of every day in the month
    double prev = 0;
    final List<double> expense = days.map((date) {
      final txs =
          snapshot.data.where((t) => t.first.isAtSameMomentAs(date)).toList();
      // If there are expense transactions on that day, return the amount.
      if (txs.isNotEmpty) return txs.first.second;
      // Otherwise Zero.
      return 0.0;
    }).map((double d) {
      // Set each next day as previous day + amount of day.
      return prev += d;
    }).toList();

    // Go over the expenses and add a prediction for future days.
    double gradient = 0;
    bool isToday = true;
    int todayIdx = 0;
    for (int i = 0; i < days.length; i++) {
      // Once the days are after the current date, the values are a prediction
      if (days[i].isAfter(_todayDate)) {
        if (isToday) {
          // expense[i] is the sum of all expenses up to day i
          gradient = expense[i] / (i + 1);
          isToday = false;
          todayIdx = i;
        }
        if (i > 0) {
          expense[i] += gradient * (i - todayIdx);
        }
      }
    }

    final List<PredictionPointDate> dataPoints = [];
    for (int i = 0; i < days.length; i++) {
      dataPoints.add(PredictionPointDate(
        timestamp: days[i],
        amount: expense[i],
        isPrediction: days[i].isAfter(_todayDate),
        isAboveMax: expense[i] > (widget.monthlyBudget ?? 0.0),
      ));
    }
    return dataPoints;
  }
}

class PredictionDateChart extends StatelessWidget {
  final List<charts.Series<dynamic, DateTime>> seriesList;
  final bool animate;

  const PredictionDateChart(this.seriesList, {this.animate});

  factory PredictionDateChart.withTransactions(
      List<PredictionPointDate> data, double monthlyMaxBudget) {
    final List<charts.Series<dynamic, DateTime>> outputData = [
      charts.Series<PredictionPointDate, DateTime>(
          data: data,
          id: "SpendingPrediction",
          domainFn: (PredictionPointDate ce, _) => ce.timestamp,
          measureFn: (PredictionPointDate ce, _) => ce.amount,
          colorFn: (PredictionPointDate ce, _) => ce.isAboveMax
              ? charts.MaterialPalette.red.shadeDefault.darker.darker
              : charts.MaterialPalette.deepOrange.shadeDefault,
          strokeWidthPxFn: (PredictionPointDate pp, _) =>
              pp.isPrediction ? 1 : 1.8,
          dashPatternFn: (PredictionPointDate ce, _) =>
              ce.isPrediction ? [3, 3] : null),
      charts.Series<double, DateTime>(
          data: [monthlyMaxBudget, monthlyMaxBudget],
          id: "MaxBudget",
          domainFn: (double d, int i) => i == 0
              ? DateTime.utc(today().year, today().month, 1)
              : today().getLastDateOfMonth(),
          measureFn: (double d, _) => d,
          colorFn: (_, __) =>
              charts.MaterialPalette.red.shadeDefault.darker.darker,
          strokeWidthPxFn: (_, __) => 1,
          areaColorFn: (_, __) => charts.MaterialPalette.transparent)
    ];

    return PredictionDateChart(
      outputData,
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: false,
      defaultInteractions: false,
      defaultRenderer: charts.LineRendererConfig(
        roundEndCaps: true,
        strokeWidthPx: 1.8,
        areaOpacity: 0.3,
      ),
      domainAxis: charts.DateTimeAxisSpec(
        renderSpec: charts.SmallTickRendererSpec<DateTime>(
            tickLengthPx: 4,
            labelStyle: charts.TextStyleSpec(
              color: charts.ColorUtil.fromDartColor(Colors.grey.shade600),
            ),
            lineStyle: charts.LineStyleSpec(
              color: charts.ColorUtil.fromDartColor(Colors.grey.shade600),
            )),
        tickFormatterSpec: const charts.AutoDateTimeTickFormatterSpec(
          day: charts.TimeFormatterSpec(format: "d", transitionFormat: "d"),
        ),
        tickProviderSpec: const charts.DayTickProviderSpec(increments: [3]),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            color: charts.ColorUtil.fromDartColor(Colors.grey.shade600),
          ),
          lineStyle: charts.LineStyleSpec(
            dashPattern: const [6, 6],
            color: charts.ColorUtil.fromDartColor(Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}
