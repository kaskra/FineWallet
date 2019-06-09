/*
 * Developed by Lukas Krauch 9.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class LineChart extends StatefulWidget {
  LineChart({@required this.data, @required this.lineColor});

  final List<double> data;
  final MonthlyChartType type;
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
    doublePainter.color = lineColor ?? Colors.black;
    doublePainter.additionalData = additionalData;
    doublePainter.update();

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1),
          color: Colors.transparent),
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

  final int upperSpace = 20;
  List<double> indices;

  DoublePainter(
      {List<double> data, Color color, List<List<double>> additionalData}) {
    this.data = data;

    this.additionalData = additionalData;
    this.color = color;
    if (data != null) {
      indices = List.generate(data.length, (int index) => index.toDouble() + 1);
    }
  }

  void update() {
    if (data != null) {
      indices = List.generate(data.length, (int index) => index.toDouble() + 1);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    throw Exception(
        "Not implemented on parent class. Try creating an instance of a subtype.");
  }

  @override
  bool shouldRepaint(DoublePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(DoublePainter oldDelegate) => false;
}

class LineChartPainter extends DoublePainter {
  @override
  void paint(Canvas canvas, Size size) {
    // super.paint(canvas, size);
    if (data.length <= 0) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final height = size.height;
    final width = size.width;
    Path path = Path();

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
  void paint(Canvas canvas, Size size) {
    if (data.length <= 0) return;

    // TODO more checks

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

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
