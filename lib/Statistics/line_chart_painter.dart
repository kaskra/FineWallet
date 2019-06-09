/*
 * Developed by Lukas Krauch 9.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */
import 'dart:math';

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
