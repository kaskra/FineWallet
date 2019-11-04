/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:20:08 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/resources/blocs/transaction_bloc.dart';
import 'package:FineWallet/core/resources/transaction_list.dart';
import 'package:FineWallet/src/statistics/chart_data.dart';
import 'package:FineWallet/utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpendingPredictionChart extends StatefulWidget {
  SpendingPredictionChart({this.monthlyBudget = 0});

  final double monthlyBudget;

  @override
  _SpendingPredictionChartState createState() =>
      _SpendingPredictionChartState();
}

class _SpendingPredictionChartState extends State<SpendingPredictionChart> {
  DateTime _today;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    setState(() {
      _today = DateTime.utc(now.year, now.month, now.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: _buildChart(),
      ),
    );
  }

  Widget _buildChart() {
    return Consumer<TransactionBloc>(
      builder: (_, bloc, child) {
        bloc.getMonthlyTransactions();
        return StreamBuilder(
          stream: bloc.monthlyTransactions,
          builder: (context, AsyncSnapshot<TransactionList> snapshot) {
            if (snapshot.hasData) {
              // Decide between using DateTime and int as index.

              // return PredictionChart.withTransactions(
              //     _calcDataPoints(snapshot), widget.monthlyBudget);

              return PredictionDateChart.withTransactions(
                  _calcDateTimeDataPoints(snapshot), widget.monthlyBudget);
            }
            return Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  List<PredictionPoint> _calcDataPoints(
      AsyncSnapshot<TransactionList> snapshot) {
    // all days of month as date in millis
    List<double> data = getListOfMonthDays(_today);

    int todayInMillis = dayInMillis(_today);

    // calc the step function by using all expenses of every day in the month
    double prev = 0;
    List<double> expense = data
        .map((date) => snapshot.data.byDayInMillis(date.toInt()).sumExpenses())
        .map((double d) {
      prev += d;
      return prev;
    }).toList();

    double gradient = 0;
    bool isToday = true;
    int todayIdx = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i] > todayInMillis) {
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

    List<int> days = data
        .map((d) => DateTime.fromMillisecondsSinceEpoch(d.toInt()).day)
        .toList();

    List<PredictionPoint> dataPoints = [];
    for (int i = 0; i < days.length; i++) {
      bool isPrediction = i > todayIdx;
      bool isAboveMax = expense[i] > widget.monthlyBudget;
      dataPoints
          .add(PredictionPoint(days[i], expense[i], isPrediction, isAboveMax));
    }
    return dataPoints;
  }

  List<PredictionPointDate> _calcDateTimeDataPoints(
      AsyncSnapshot<TransactionList> snapshot) {
    // all days of month as date in millis
    List<double> data = getListOfMonthDays(_today);

    // finer day steps
    for (int i = 0; i < data.length - 1; i += 2) {
      data.insert(i + 1, data[i] + (data[i + 1] - data[i]) / 2);
    }

    int todayInMillis = dayInMillis(_today);

    // calc the step function by using all expenses of every day in the month
    double prev = 0;
    List<double> expense = data
        .map((date) => snapshot.data.byDayInMillis(date.toInt()).sumExpenses())
        .map((double d) {
      prev += d;
      return prev;
    }).toList();

    double gradient = 0;
    bool isToday = true;
    int todayIdx = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i] > todayInMillis) {
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

    List<DateTime> days = data
        .map((d) => DateTime.fromMillisecondsSinceEpoch(d.toInt()))
        .toList();

    List<PredictionPointDate> dataPoints = [];
    for (int i = 0; i < days.length; i++) {
      bool isPrediction = i > todayIdx;
      bool isAboveMax = expense[i] > widget.monthlyBudget;
      dataPoints.add(
          PredictionPointDate(days[i], expense[i], isPrediction, isAboveMax));
    }
    return dataPoints;
  }
}

class PredictionDateChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  PredictionDateChart(this.seriesList, {this.animate});

  factory PredictionDateChart.withTransactions(
      List<PredictionPointDate> data, double monthlyMaxBudget) {
    List<charts.Series<dynamic, DateTime>> outputData = [
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
              ? DateTime.utc(DateTime.now().year, DateTime.now().month, 1)
              : getLastDateOfMonth(DateTime.now()),
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
    return new charts.TimeSeriesChart(
      seriesList,
      animate: false,
      defaultRenderer: charts.LineRendererConfig(
          roundEndCaps: true, strokeWidthPx: 1.8, areaOpacity: 0.3),
      domainAxis: charts.DateTimeAxisSpec(
          showAxisLine: true,
          tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
              day:
                  charts.TimeFormatterSpec(format: "d", transitionFormat: "d")),
          tickProviderSpec: charts.DayTickProviderSpec(increments: [3])),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
            lineStyle: charts.LineStyleSpec(dashPattern: [6, 6])),
      ),
    );
  }
}

class PredictionChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  PredictionChart(this.seriesList, {this.animate});

  factory PredictionChart.withTransactions(
      List<PredictionPoint> data, double monthlyMaxBudget) {
    List<charts.Series<dynamic, int>> outputData = [
      charts.Series<PredictionPoint, int>(
          data: data,
          id: "SpendingPrediction",
          domainFn: (PredictionPoint ce, _) => ce.timestamp,
          measureFn: (PredictionPoint ce, _) => ce.amount,
          colorFn: (PredictionPoint ce, _) => ce.isAboveMax
              ? charts.MaterialPalette.red.shadeDefault.darker.darker
              : charts.MaterialPalette.deepOrange.shadeDefault,
          strokeWidthPxFn: (PredictionPoint pp, _) => pp.isPrediction ? 1 : 1.8,
          dashPatternFn: (PredictionPoint ce, _) =>
              ce.isPrediction ? [3, 3] : null),
      charts.Series<double, int>(
          data: [monthlyMaxBudget, monthlyMaxBudget],
          id: "MaxBudget",
          domainFn: (double d, int i) => i == 0 ? 0 : data.length,
          measureFn: (double d, _) => d,
          colorFn: (_, __) =>
              charts.MaterialPalette.red.shadeDefault.darker.darker,
          strokeWidthPxFn: (_, __) => 1,
          areaColorFn: (_, __) => charts.MaterialPalette.transparent)
    ];

    return PredictionChart(
      outputData,
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList,
        animate: false,
        defaultRenderer: charts.LineRendererConfig(
            roundEndCaps: true, strokeWidthPx: 1.8, areaOpacity: 0.3),
        domainAxis: charts.NumericAxisSpec(
            tickProviderSpec:
                charts.StaticNumericTickProviderSpec(<charts.TickSpec<int>>[
          charts.TickSpec<int>(1),
          charts.TickSpec<int>(6),
          charts.TickSpec<int>(12),
          charts.TickSpec<int>(18),
          charts.TickSpec<int>(24),
          charts.TickSpec<int>(30),
        ])),
        primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
              lineStyle: charts.LineStyleSpec(dashPattern: [6, 6])),
        ));
  }
}
