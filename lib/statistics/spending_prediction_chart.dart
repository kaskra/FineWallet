/*
 * Developed by Lukas Krauch 13.7.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:FineWallet/resources/blocs/transaction_bloc.dart';
import 'package:FineWallet/resources/transaction_list.dart';
import 'package:FineWallet/statistics/chart_data.dart';
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
              return PredictionChart.withTransactions(
                  _calcDataPoints(snapshot), widget.monthlyBudget);
            }
            return Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  List<PredictionPoint> _calcDataPoints(
      AsyncSnapshot<TransactionList> snapshot) {
    List<double> data = getListOfMonthDays(_today);

    int todayInMillis = dayInMillis(_today);
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

  // TODO add more points in between for smoother color movement
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
