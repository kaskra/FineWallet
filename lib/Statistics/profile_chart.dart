/*
 * Developed by Lukas Krauch 29.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';

class CircularProfileChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  CircularProfileChart(this.seriesList, {this.animate});

  factory CircularProfileChart.withSampleData() {
    return new CircularProfileChart(_createSampleData(), animate: false);
  }

  static List<charts.Series<CategoryExpenses, int>> _createSampleData() {
    final data = [
      new CategoryExpenses(128, 1, "Test1"),
      new CategoryExpenses(64, 2, "Test2"),
      new CategoryExpenses(32, 3, "Test3"),
      new CategoryExpenses(16, 4, "Test4"),
      new CategoryExpenses(8, 5, "Test5"),
    ];

    return [
      charts.Series<CategoryExpenses, int>(
        data: data,
        id: "CategoryExpenses",
        domainFn: (CategoryExpenses ce, _) => ce.categoryId,
        measureFn: (CategoryExpenses ce, _) => ce.amount,
        labelAccessorFn: (CategoryExpenses ce, _) => ce.categoryName,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: animate,
      defaultInteractions: true,
      defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
        new charts.ArcLabelDecorator(
            leaderLineStyleSpec: charts.ArcLabelLeaderLineStyleSpec(
                length: 10, color: charts.Color.black, thickness: 1),
            showLeaderLines: true,
            labelPosition: charts.ArcLabelPosition.outside)
      ], arcWidth: 25),
    );
  }
}

class CategoryExpenses {
  final double amount;
  final int categoryId;
  final String categoryName;

  CategoryExpenses(this.amount, this.categoryId, this.categoryName);
}
