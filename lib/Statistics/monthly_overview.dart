/*
 * Developed by Lukas Krauch 9.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/Resources/DBProvider.dart';
import 'package:finewallet/Statistics/chartstyle.dart';
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
  final PageController _controller = PageController(viewportFraction: 0.8);

  DateTime _date;

  @override
  void initState() {
    super.initState();
    _date = widget.initialMonth;
  }

  Widget _navigationRow() {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: InkWell(
                child: Container(
                  child: Icon(Icons.keyboard_arrow_left),
                  width: 40,
                  height: 50,
                ),
                onTap: () {
                  DateTime firstOfCurrentMonth =
                      DateTime.utc(_date.year, _date.month, 1);
                  DateTime prevMonth =
                      firstOfCurrentMonth.add(Duration(days: -1));
                  setState(() {
                    _date = DateTime.utc(prevMonth.year, prevMonth.month, 15);
                  });
                },
              )),
          Container(
            child: Text(
              "${getMonthName(_date.month)} ${_date.year}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                DateTime lastOfCurrentMonth = DateTime.utc(
                    _date.year, _date.month, getLastDayOfMonth(_date));
                DateTime nextMonth = lastOfCurrentMonth.add(Duration(days: 1));
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
        title: Text("Monthly"),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        // border: Border.all(color: Colors.orange, width: 1),
      ),
      padding: EdgeInsets.only(left: 45, right: 45, top: 15, bottom: 15),
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          FutureBuilder(
            future: DBProvider.db
                .getTransactionsOfMonth(widget.month.millisecondsSinceEpoch),
            builder: (context, AsyncSnapshot<List<TransactionModel>> snapshot) {
              if (snapshot.hasData) {
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
                        .fold(
                            0.0,
                            (double prev, curr) =>
                                (prev + curr.amount.toDouble())))
                    .toList();

                List<double> income = data
                    .map((date) => snapshot.data
                        .where((item) => item.date == date)
                        .where((item) => item.isExpense == 0)
                        .fold(
                            0.0,
                            (double prev, curr) =>
                                (prev + curr.amount.toDouble())))
                    .toList();

                return Column(
                  children: <Widget>[
                    MonthlyChart(
                      data: expense,
                      type: _type,
                      lineColor: Colors.blue,
                      additionalData: [income],
                      style: ChartStyle(
                          border: Border.all(color: Colors.black12, width: 1),
                          backgroundColor: Colors.transparent,
                          strokeWidth: 2.5),
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
          )
        ],
      ),
    );
  }
}
