/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:19:59 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/datatypes/tuple.dart';
import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/src/statistics/chart_data.dart';
import 'package:FineWallet/utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileChart extends StatefulWidget {
  ProfileChart({this.type = MONTHLY_CHART});

  static const int LIFE_CHART = 2;
  static const int MONTHLY_CHART = 1;

  final int type;

  @override
  _ProfileChartState createState() => _ProfileChartState();
}

class _ProfileChartState extends State<ProfileChart> {
  /// Returns a [StreamBuilder] that displays a chart with expenses per category.
  ///
  /// Return
  /// -----
  /// [AsyncSnapshot] of [Tuple3]s with category id, category name and
  /// expense per category.
  StreamBuilder<List<Tuple3<int, String, double>>> _buildChartWithData() {
    // Check which chart should be displayed and load the correct data for it.
    var settings;
    if (widget.type == ProfileChart.MONTHLY_CHART) {
      settings = TransactionFilterSettings(
        dateInMonth: dayInMillis(DateTime.now()),
        expenses: true,
      );
    } else {
      settings = TransactionFilterSettings(expenses: true);
    }

    return StreamBuilder<List<Tuple3<int, String, double>>>(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchSumOfTransactionsByCategories(settings),
      builder: (context, transactionSnapshot) {
        return _buildChart(transactionSnapshot);
      },
    );
  }

  /// Builds the [CircularProfileChart] to display the expenses per
  /// category with names.
  ///
  /// Input
  /// -----
  /// [AsyncSnapshot] of [Tuple3]s with category id, category name and
  /// expense per category.
  ///
  /// Return
  /// ------
  /// Resulting [CircularProfileChart].
  Widget _buildChart(
      AsyncSnapshot<List<Tuple3<int, String, double>>> transactionSnapshot) {
    if (transactionSnapshot.hasData) {
      // Get the summed up expenses, ids and names for each category.
      final ids = transactionSnapshot.data.map((l) => l.first).toList();
      final names = transactionSnapshot.data.map((l) => l.second).toList();
      final expenses = transactionSnapshot.data.map((l) => l.third).toList();

      // Create the chart with expenses per category and category names.
      return CircularProfileChart.withTransactions(expenses, ids, names);
    }
    return Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: _buildChartWithData(),
      ),
    );
  }
}

class CircularProfileChart extends StatelessWidget {
  CircularProfileChart(this.seriesList, {this.animate});

  factory CircularProfileChart.withTransactions(
      List<double> expenses, List<int> categories, List<String> categoryNames) {
    List<CategoryExpenses> inputData = [];
    for (int i = 0; i < expenses.length; i++) {
      if (expenses[i] > 0)
        inputData.add(
            CategoryExpenses(expenses[i], categories[i], categoryNames[i]));
    }

    List<charts.Series<CategoryExpenses, int>> data = [];
    if (inputData.length > 0) {
      data = [
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
    } else {
      data = [
        charts.Series<CategoryExpenses, int>(
            data: [CategoryExpenses(0, 0, "0")],
            id: "CategoryExpenses",
            domainFn: (CategoryExpenses ce, _) => 0,
            measureFn: (CategoryExpenses ce, _) => 1,
            labelAccessorFn: (CategoryExpenses ce, _) => "",
            colorFn: (CategoryExpenses ce, int i) =>
                charts.MaterialPalette.gray.shade200)
      ];
    }
    return CircularProfileChart(
      data,
      animate: false,
    );
  }

  final bool animate;
  final List<charts.Series> seriesList;

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
                  length: 10,
                  color: charts.ColorUtil.fromDartColor(
                      Theme.of(context).colorScheme.onSecondary),
                  thickness: 1),
              showLeaderLines: true,
              outsideLabelStyleSpec: charts.TextStyleSpec(
                  fontSize: 12,
                  color: charts.ColorUtil.fromDartColor(
                      Theme.of(context).colorScheme.onSecondary)),
              labelPosition: charts.ArcLabelPosition.outside),
        ],
        arcWidth: 25,
      ),
    );
  }
}
