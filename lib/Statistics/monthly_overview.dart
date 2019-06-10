/*
 * Developed by Lukas Krauch 10.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/Resources/DBProvider.dart';
import 'package:finewallet/Statistics/chart_type.dart';
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
  ChartType _type = ChartType.LINE;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _type = fromIntToChartType(prefs.getInt("chart_type"));
  }

  _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("chart_type", fromChartTypeToInt(_type));
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
                child: ExpenseIncomeChart(buildSeries(dataPoints), _type),
                height: 300,
              ),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    _type = _type == ChartType.LINE
                        ? ChartType.BAR
                        : ChartType.LINE;
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
      padding: EdgeInsets.only(left: 15, right: 10, top: 10),
//      margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: _buildChart(),
    );
  }
}

class ExpenseIncomeChart extends StatelessWidget {
  final List<charts.Series<DataPoint, int>> seriesList;
  final bool animate;
  final ChartType type;

  ExpenseIncomeChart(this.seriesList, this.type, {this.animate});

  Widget _buildLineChart() {
    return new charts.LineChart(seriesList,
        animate: true,
        animationDuration: Duration(milliseconds: 150),
        defaultRenderer: charts.LineRendererConfig(
          roundEndCaps: true,
          strokeWidthPx: 2,
          includeArea: true,
        ),
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
                dataIsInWholeNumbers: true, desiredTickCount: 5)));
  }

  Widget _buildBarChart() {
    List<charts.Series<DataPoint, String>> series = seriesList
        .map((list) => new charts.Series<DataPoint, String>(
            id: list.id,
            data: list.data,
            domainFn: (DataPoint p, _) => p.timeStamp.toString(),
            measureFn: (DataPoint p, _) =>
                list.id == 'Expense' ? p.expense : p.income))
        .toList();

    return new charts.BarChart(series,
        animate: true,
        animationDuration: Duration(milliseconds: 150),
        defaultRenderer: charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.grouped,
          strokeWidthPx: 2,
        ),
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
        domainAxis: charts.OrdinalAxisSpec(
            renderSpec: charts.SmallTickRendererSpec(labelOffsetFromAxisPx: 4),
            tickProviderSpec:
                charts.StaticOrdinalTickProviderSpec(<charts.TickSpec<String>>[
              charts.TickSpec<String>('1'),
              charts.TickSpec<String>('6'),
              charts.TickSpec<String>('12'),
              charts.TickSpec<String>('18'),
              charts.TickSpec<String>('24'),
              charts.TickSpec<String>('30'),
            ])),
        primaryMeasureAxis: charts.NumericAxisSpec(
            renderSpec: charts.SmallTickRendererSpec(labelOffsetFromTickPx: 0),
            tickProviderSpec: charts.BasicNumericTickProviderSpec(
                dataIsInWholeNumbers: true, desiredTickCount: 5)));
  }

  @override
  Widget build(BuildContext context) {
    if (type == ChartType.LINE) {
      return _buildLineChart();
    } else if (type == ChartType.BAR) {
      return _buildBarChart();
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class DataPoint {
  final int timeStamp;
  final double expense;
  final double income;
  DataPoint(this.timeStamp, this.expense, this.income);
}
