import 'dart:math';

import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/Resources/DBProvider.dart';
import 'package:finewallet/monthly_chart.dart';
import 'package:finewallet/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';

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
                  print("Backward!");
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
                print("Forward");
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
            month: DateTime.now(),
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
  List<double> _values;
  double _avg;
  double _incomeSum;
  double _expenseSum;

  @override
  void initState() {
    super.initState();
    // some random test data
    _values = List.generate(
        31, (int index) => Random().nextDouble() * Random().nextInt(100));
    _incomeSum = 1750;
    _expenseSum = _values.fold(0, (prev, next) => prev + next);
    _avg = _expenseSum / _values.length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.orange, width: 1),
      ),
      padding: EdgeInsets.only(left: 45, right: 45, top: 15, bottom: 15),
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          FutureBuilder(
            future: DBProvider.db.getExpensesGroupedByDay(),
            builder:
                (context, AsyncSnapshot<List<SumOfTransactionModel>> snapshot) {
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

                data = data
                    .map((date) => snapshot.data
                        .firstWhere((item) => item.date == date,
                            orElse: () =>
                                SumOfTransactionModel(amount: 0, date: 0))
                        .amount
                        .toDouble())
                    .toList();
                    
                return LineChart(
                  data: data,
                  lineColor: Colors.black,
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
