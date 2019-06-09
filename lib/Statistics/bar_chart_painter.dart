/*
 * Developed by Lukas Krauch 9.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */
import 'dart:math';

import 'package:finewallet/Statistics/double_painter.dart';
import 'package:flutter/material.dart';

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
