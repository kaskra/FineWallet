/*
 * Project: FineWallet
 * Last Modified: Monday, 30th September 2019 11:18:27 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/month_dao.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class IncomeExpenseChart extends StatelessWidget {
  final List<Series> seriesList;

  const IncomeExpenseChart({Key key, this.seriesList}) : super(key: key);

  factory IncomeExpenseChart.withData(MonthWithDetails m) {
    return new IncomeExpenseChart(
      seriesList: _createData(m),
    );
  }

  static List<Series<double, int>> _createData(MonthWithDetails m) {
    double max = m.month.maxBudget;
    double curr = m.expense;

    double firstPart = curr / max;
    double secondPart = 1 - firstPart;

    Series<double, int> series = Series<double, int>(
      data: [firstPart, secondPart],
      domainFn: (_, i) => i,
      measureFn: (d, _) => d,
      colorFn: (d, i) => i == 0
          ? Color.fromHex(code: "#FF9800")
          : Color.fromHex(code: "#BBBBBB"),
    );
    return [series];
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(
      seriesList,
      animate: true,
      defaultRenderer: ArcRendererConfig(arcWidth: 5, strokeWidthPx: 0),
      defaultInteractions: true,
    );
  }
}
