/*
 * Developed by Lukas Krauch 10.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/Resources/DBProvider.dart';
import 'package:finewallet/Statistics/monthly_chart.dart';
import 'package:finewallet/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonthlyOverview extends StatefulWidget {
  MonthlyOverview({@required this.initialMonth});

  final DateTime initialMonth;

  @override
  _MonthlyOverviewState createState() => _MonthlyOverviewState();
}

class _MonthlyOverviewState extends State<MonthlyOverview> {
  DateTime _date;

  @override
  void initState() {
    super.initState();
    _date = widget.initialMonth;
  }

  Widget _navigationRow() {
    DateTime firstOfCurrentMonth = DateTime.utc(_date.year, _date.month, 1);
    DateTime prevMonth = firstOfCurrentMonth.add(Duration(days: -1));
    DateTime lastOfCurrentMonth =
        DateTime.utc(_date.year, _date.month, getLastDayOfMonth(_date));
    DateTime nextMonth = lastOfCurrentMonth.add(Duration(days: 1));

    return Container(
      margin: EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 12, 5),
              child: InkWell(
                child: Container(
                  child: Icon(Icons.keyboard_arrow_left),
                  width: 40,
                  height: 50,
                ),
                onTap: () {
                  setState(() {
                    _date = DateTime.utc(prevMonth.year, prevMonth.month, 15);
                  });
                },
              )),
          Expanded(
            child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.005)
                  ..rotateY(0.8),
                child: Container(
                  child: Text(
                    "${getMonthName(prevMonth.month, abbrev: true)}",
                    style: TextStyle(fontSize: 17),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                )),
          ),
          Expanded(
              flex: 5,
              child: Center(
                child: Container(
                  child: Text(
                    "${getMonthName(_date.month)} ${_date.year}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )),
          Expanded(
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(1, 2, 0.03)
                ..rotateY(0.8),
              child: Container(
                  child: Text(
                "${getMonthName(nextMonth.month, abbrev: true)}",
                style: TextStyle(fontSize: 17),
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
              )),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: InkWell(
              child: Container(
                child: Icon(Icons.keyboard_arrow_right),
                width: 40,
                height: 50,
              ),
              onTap: () {
                setState(() {
                  _date = DateTime.utc(nextMonth.year, nextMonth.month, 15);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffd8e7ff),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Monthly",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _navigationRow(),
          MonthCard(
            month: _date,
          )
        ],
      ),
    );
  }
}

class MonthCard extends StatefulWidget {
  MonthCard({Key key, @required this.month}) : super(key: key);

  final DateTime month;

  _MonthCardState createState() => _MonthCardState();
}

class _MonthCardState extends State<MonthCard> {
  MonthlyChartType _type = MonthlyChartType.LINE;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _type = fromIntToMonthlyChartType(prefs.getInt("chart_type"));
  }

  _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("chart_type", fromMonthlyChartTypeToInt(_type));
  }

  List<charts.Series<DataPoint, int>> buildSeries(List<DataPoint> points) {
    var expenses = new charts.Series<DataPoint, int>(
        id: 'Expense',
        data: points,
        domainFn: (DataPoint p, _) => p.timeStamp,
        measureFn: (DataPoint p, _) => p.expense);
    var income = new charts.Series(
        id: 'Income',
        data: points,
        domainFn: (DataPoint p, _) => p.timeStamp,
        measureFn: (DataPoint p, _) => p.income);
    return [expenses, income];
  }

  Widget _buildChart() {
    return FutureBuilder(
      future: DBProvider.db
          .getTransactionsOfMonth(widget.month.millisecondsSinceEpoch),
      builder: (context, AsyncSnapshot<List<TransactionModel>> snapshot) {
        if (snapshot.hasData) {
          List<DataPoint> dataPoints = generateDataPoints(snapshot);
          return Column(
            children: <Widget>[
              SizedBox(
                child: IntegerOnlyMeasureAxis(buildSeries(dataPoints)),
                height: 300,
              ),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    _type = _type == MonthlyChartType.LINE
                        ? MonthlyChartType.BAR
                        : MonthlyChartType.LINE;
                  });
                  _savePrefs();
                },
                child: Text("Switch"),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  List<DataPoint> generateDataPoints(
      AsyncSnapshot<List<TransactionModel>> snapshot) {
    DateTime date = widget.month ?? DateTime.now();

    int lastDay = getLastDayOfMonth(date);
    DateTime firstOfMonth = DateTime.utc(date.year, date.month, 1);
    DateTime lastOfMonth =
        DateTime.utc(date.year, date.month, lastDay, 23, 59, 59);

    List<double> data = List();
    for (var i = firstOfMonth.millisecondsSinceEpoch;
        i < lastOfMonth.millisecondsSinceEpoch;
        i = i + Duration(days: 1).inMilliseconds) {
      int day = dayInMillis(DateTime.fromMillisecondsSinceEpoch(i));
      data.add(day.toDouble());
    }

    List<double> expense = data
        .map((date) => snapshot.data
            .where((item) => item.date == date)
            .where((item) => item.isExpense == 1)
            .fold(0.0, (double prev, curr) => (prev + curr.amount.toDouble())))
        .toList();

    List<double> income = data
        .map((date) => snapshot.data
            .where((item) => item.date == date)
            .where((item) => item.isExpense == 0)
            .fold(0.0, (double prev, curr) => (prev + curr.amount.toDouble())))
        .toList();
    List<int> days = data
        .map((d) => DateTime.fromMillisecondsSinceEpoch(d.toInt()).day)
        .toList();

    List<DataPoint> dataPoints = [];
    for (int i = 0; i < days.length; i++) {
      dataPoints.add(DataPoint(days[i], expense[i], income[i]));
    }
    return dataPoints;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
//        border: Border.all(color: Colors.orange, width: 1),
      ),
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
//      margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: _buildChart(),
    );
  }
}

class IntegerOnlyMeasureAxis extends StatelessWidget {
  final List<charts.Series<DataPoint, int>> seriesList;
  final bool animate;

  IntegerOnlyMeasureAxis(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
      seriesList,
      animate: true,
      defaultRenderer:
          charts.LineRendererConfig(roundEndCaps: true, strokeWidthPx: 2),
    );
  }
}

class DataPoint {
  final int timeStamp;
  final double expense;
  final double income;
  DataPoint(this.timeStamp, this.expense, this.income);
}
