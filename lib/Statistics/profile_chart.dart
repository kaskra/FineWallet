/*
 * Developed by Lukas Krauch 10.7.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:finewallet/Models/category_model.dart';
import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/Statistics/chart_data.dart';
import 'package:finewallet/resources/category_list.dart';
import 'package:finewallet/resources/category_provider.dart';
import 'package:finewallet/resources/transaction_list.dart';
import 'package:finewallet/resources/transaction_provider.dart';
import 'package:finewallet/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileChart extends StatefulWidget {
  static const int MONTHLY_CHART = 1;
  static const int LIFE_CHART = 2;

  ProfileChart({this.type = MONTHLY_CHART});

  final int type;

  @override
  _ProfileChartState createState() => _ProfileChartState();
}

class _ProfileChartState extends State<ProfileChart> {
  List<int> categories;
  List<String> categoryNames;
  DateTime today;

  @override
  void initState() {
    super.initState();
    _getCategories();
    DateTime now = DateTime.now();
    setState(() {
      today = DateTime.utc(now.year, now.month, now.day);
    });
  }

  void _getCategories() async {
    CategoryList cate =
        await CategoryProvider.db.getAllCategories(isExpense: true);
    setState(() {
      categories = cate.map((CategoryModel category) => category.id).toList();
      categoryNames =
          cate.map((CategoryModel category) => category.name).toList();
    });
  }

  Widget _buildChart() {
    Future<TransactionList> transactionFuture =
        widget.type == ProfileChart.MONTHLY_CHART
            ? TransactionsProvider.db.getTransactionsOfMonth(dayInMillis(today))
            : TransactionsProvider.db
                .getAllTrans(dayInMillis(getLastDateOfMonth(today)));

    return FutureBuilder(
        future: transactionFuture,
        builder: (context, AsyncSnapshot<TransactionList> snapshot) {
          if (snapshot.hasData && categories != null) {
            List<double> expenses = [];
            for (int c in categories) {
              double ex = snapshot.data
                  .where((TransactionModel tx) => tx.category == c)
                  .sumExpenses();
              expenses.add(ex);
            }
            return CircularProfileChart.withTransactions(
                expenses, categories, categoryNames);
          }
          return Center(child: CircularProgressIndicator());
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
}

class CircularProfileChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  CircularProfileChart(this.seriesList, {this.animate});

  factory CircularProfileChart.withTransactions(
      List<double> expenses, List<int> categories, List<String> categoryNames) {
    List<CategoryExpenses> inputData = [];
    for (int i = 0; i < expenses.length; i++) {
      if (expenses[i] > 0)
        inputData.add(
            CategoryExpenses(expenses[i], categories[i], categoryNames[i]));
    }

    List<charts.Series<CategoryExpenses, int>> data = [
      charts.Series<CategoryExpenses, int>(
          data: inputData,
          id: "CategoryExpenses",
          domainFn: (CategoryExpenses ce, _) => ce.categoryId,
          measureFn: (CategoryExpenses ce, _) => ce.amount,
          labelAccessorFn: (CategoryExpenses ce, _) => ce.categoryName,
          colorFn: (CategoryExpenses ce, int i) => charts
              .MaterialPalette.deepOrange
              .makeShades(categories.length)[i])
    ];

    return CircularProfileChart(
      data,
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: animate,
      defaultInteractions: true,
      defaultRenderer: new charts.ArcRendererConfig(
        arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              leaderLineStyleSpec: charts.ArcLabelLeaderLineStyleSpec(
                  length: 10, color: charts.Color.black, thickness: 1),
              showLeaderLines: true,
              outsideLabelStyleSpec: charts.TextStyleSpec(fontSize: 12),
              labelPosition: charts.ArcLabelPosition.outside),
        ],
        arcWidth: 25,
      ),
    );
  }
}
