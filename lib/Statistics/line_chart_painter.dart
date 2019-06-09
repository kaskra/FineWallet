/*
 * Developed by Lukas Krauch 9.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */
import 'package:finewallet/Statistics/double_painter.dart';
import 'package:flutter/material.dart';

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
    final xMargin = width / data.length;
    final yMargin = height / maxDataValue;

    path.moveTo(indices[0], data[0] * yMargin);

    for (var i = 0; i < data.length; i++) {
      double x = indices[i] * xMargin;
      double y = data[i] * yMargin;
      path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }
}
