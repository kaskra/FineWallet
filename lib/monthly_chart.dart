/*
 * Developed by Lukas Krauch 9.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

enum MonthlyChartType { LINE, BAR }

class ChartStyle {
  ChartStyle(
      {this.strokeWidth = 1,
      this.paintingStyle = PaintingStyle.stroke,
      this.backgroundColor = Colors.white,
      this.border});

  final double strokeWidth;
  final PaintingStyle paintingStyle;
  final Color backgroundColor;
  final Border border;

  static const defaultLineColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.black,
    Colors.cyan
  ];
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

  static CustomPainter getPainterFromType(MonthlyChartType type) {
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

class DoublePainter extends CustomPainter {
  List<List<double>> additionalData;
  List<double> data;
  Color color;
  ChartStyle style;

  final int upperSpace = 20;
  final List<Color> defaultColors = ChartStyle.defaultLineColors;

  List<double> indices;
  double strokeWidth = 1;
  PaintingStyle paintingStyle = PaintingStyle.stroke;

  DoublePainter(
      {List<double> data, Color color, List<List<double>> additionalData}) {
    this.data = data;
    this.additionalData = additionalData;
    this.color = color ?? defaultColors.first;
    if (data != null) {
      indices = List.generate(data.length, (int index) => index.toDouble() + 1);
    }
  }

  void update() {
    if (data != null) {
      indices = List.generate(data.length, (int index) => index.toDouble() + 1);
    }
    if (style != null) {
      strokeWidth = style.strokeWidth;
      paintingStyle = style.paintingStyle;
    }
    if (color == null) {
      color = defaultColors.first;
    }
    if (additionalData != null) {
      if (additionalData.length >
          (defaultColors.where((color) => color != this.color)).length) {
        additionalData = additionalData.sublist(
            0, defaultColors.where((color) => color != this.color).length);
      }
    }
  }

  void paintDataPoints(
      List<double> data, Color color, Canvas canvas, Size size) {
    throw Exception(
        "Not implemented on parent class. Try creating an instance of a subtype.");
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO paint ticks etc.
    if (data.length <= 0) return;

    if (indices.length <= 0) update();

    List<Color> usedColors = [color];
    paintDataPoints(data, color, canvas, size);
    for (List<double> data in additionalData ?? []) {
      Color color =
          defaultColors.where((color) => !usedColors.contains(color)).first;
      paintDataPoints(data, color, canvas, size);
      usedColors.add(color);
    }
  }

  @override
  bool shouldRepaint(DoublePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(DoublePainter oldDelegate) => false;
}

class LineChartPainter extends DoublePainter {
  @override
  void paintDataPoints(
      List<double> data, Color color, Canvas canvas, Size size) {
    Path path = Path();
    final paint = Paint()
      ..color = color
      ..style = paintingStyle
      ..strokeWidth = strokeWidth;

    final height = size.height;
    final width = size.width;
    final maxDataValue =
        data.fold(0.0, (prev, next) => max<double>(prev, next)) + upperSpace;
    final xMargin = width / data.length;
    final yMargin = height / maxDataValue;

    double y = data[0] * yMargin;
    path.moveTo(indices[0], height - y);

    for (var i = 0; i < data.length; i++) {
      y = data[i];
      path.lineTo(indices[i] * xMargin, height - y * yMargin);
    }
    canvas.drawPath(path, paint);
  }
}

class BarChartPainter extends DoublePainter {
  @override
  void paintDataPoints(
      List<double> data, Color color, Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = paintingStyle
      ..strokeWidth = strokeWidth;

    final height = size.height;
    final width = size.width;

    final maxDataValue =
        data.fold(0.0, (prev, next) => max<double>(prev, next)) + upperSpace;
    final xMargin = width / data.length;
    final yMargin = height / maxDataValue;

    for (var i = 0; i < data.length; i++) {
      Path path = Path();
      path.moveTo(indices[i] * xMargin, height);
      path.lineTo(indices[i] * xMargin, height - data[i] * yMargin);
      canvas.drawPath(path, paint);
    }
  }
}
