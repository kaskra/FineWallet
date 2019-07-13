/*
 * Developed by Lukas Krauch 13.7.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:finewallet/Statistics/chart_data.dart';
import 'package:finewallet/resources/transaction_list.dart';
import 'package:finewallet/resources/transaction_provider.dart';
import 'package:finewallet/utils.dart';
import 'package:flutter/material.dart';

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
    return FutureBuilder(
        future: TransactionsProvider.db.getAllTrans(dayInMillis(_today)),
        builder: (context, AsyncSnapshot<TransactionList> snapshot) {
          if (snapshot.hasData) {
            return PredictionChart.withTransactions(_calcDataPoints(snapshot));
          }
          return Center(child: CircularProgressIndicator());
        });
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
        if (gradient > 0 && i > 0) {
          expense[i] = expense[i - 1] + gradient;
        }
      }
    }

    List<int> days = data
        .map((d) => DateTime.fromMillisecondsSinceEpoch(d.toInt()).day)
        .toList();

    List<PredictionPoint> dataPoints = [];
    for (int i = 0; i < days.length; i++) {
      bool isPrediction = i > todayIdx;
      dataPoints.add(PredictionPoint(days[i], expense[i], isPrediction));
    }
    return dataPoints;
  }
}

class PredictionChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  PredictionChart(this.seriesList, {this.animate});

  factory PredictionChart.withTransactions(List<PredictionPoint> data) {
    List<charts.Series<PredictionPoint, int>> outputData = [
      charts.Series<PredictionPoint, int>(
          data: data,
          id: "SpendingPrediction",
          domainFn: (PredictionPoint ce, _) => ce.timestamp,
          measureFn: (PredictionPoint ce, _) => ce.amount,
          dashPatternFn: (PredictionPoint ce, _) =>
              ce.isPrediction ? [3, 0, 0, 3] : null)
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
            roundEndCaps: true,
            strokeWidthPx: 2,
//            includeArea: true,
            areaOpacity: 0.5),
        behaviors: [
          charts.ChartTitle("Days",
              behaviorPosition: charts.BehaviorPosition.bottom,
              titleOutsideJustification: charts.OutsideJustification.end,
              innerPadding: 0,
              titleStyleSpec: charts.TextStyleSpec(fontSize: 12)),
          charts.ChartTitle("€",
              behaviorPosition: charts.BehaviorPosition.start,
              titleOutsideJustification:
                  charts.OutsideJustification.endDrawArea,
              titleDirection: charts.ChartTitleDirection.horizontal,
              titleStyleSpec: charts.TextStyleSpec(fontSize: 12),
              outerPadding: 0,
              innerPadding: 0),
        ],
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
          renderSpec: charts.SmallTickRendererSpec(labelOffsetFromTickPx: 0),
          tickProviderSpec: charts.BasicNumericTickProviderSpec(
              dataIsInWholeNumbers: true,
              desiredTickCount: 10,
              desiredMaxTickCount: 10),
        ));
  }
}
