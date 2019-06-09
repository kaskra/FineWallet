/*
 * Developed by Lukas Krauch 9.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'dart:ui';

import 'package:finewallet/Statistics/bar_chart_painter.dart';
import 'package:finewallet/Statistics/chartstyle.dart';
import 'package:finewallet/Statistics/double_painter.dart';
import 'package:finewallet/Statistics/line_chart_painter.dart';
import 'package:flutter/material.dart';

enum MonthlyChartType { LINE, BAR }

MonthlyChartType fromIntToMonthlyChartType(int value) {
  switch (value) {
    case 1:
      return MonthlyChartType.LINE;
      break;
    case 2:
      return MonthlyChartType.BAR;
      break;
  }
  return MonthlyChartType.LINE;
}

int fromMonthlyChartTypeToInt(MonthlyChartType type) {
  switch (type) {
    case MonthlyChartType.LINE:
      return 1;
      break;
    case MonthlyChartType.BAR:
      return 2;
      break;
  }
  return 1;
}

CustomPainter getPainterFromType(MonthlyChartType type) {
  switch (type) {
    case MonthlyChartType.LINE:
      return LineChartPainter();
      break;
    case MonthlyChartType.BAR:
      return BarChartPainter();
      break;
  }
  return LineChartPainter();
}

class MonthlyChart extends StatelessWidget {
  MonthlyChart(
      {@required this.data,
      @required this.type,
      this.style,
      this.lineColor,
      this.additionalData});

  final List<double> data;
  final MonthlyChartType type;
  final ChartStyle style;
  final Color lineColor;
  final List<List<double>> additionalData;

  @override
  Widget build(BuildContext context) {
    DoublePainter doublePainter = getPainterFromType(type);
    doublePainter.data = data ?? List.generate(31, (_) => 0.0);
    doublePainter.color = lineColor;
    doublePainter.additionalData = additionalData;
    doublePainter.style = style;
    doublePainter.update();

    return Container(
      decoration:
          BoxDecoration(border: style.border, color: style.backgroundColor),
      child: CustomPaint(
        painter: doublePainter,
        child: Container(
          height: 120,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
