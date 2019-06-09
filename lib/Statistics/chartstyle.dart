/*
 * Developed by Lukas Krauch 9.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:flutter/material.dart';

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
