/*
 * Developed by Lukas Krauch 9.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */
import 'dart:math';
import 'dart:ui';

import 'package:finewallet/Statistics/chartstyle.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

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
  List<List<double>> allData = [];
  double maxDataValue = double.maxFinite;

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
      allData.add(data);
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
      allData.addAll(additionalData);
    }

    maxDataValue = allData
        .map((list) => list.fold(0.0, (prev, next) => max<double>(prev, next)))
        .fold(0.0, (prev, next) => max<double>(prev, next));
    maxDataValue += maxDataValue / 5;
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
    canvas.transform(Matrix4.compose(Vector3(0, size.height, 0),
            Quaternion.euler(pi, 0, pi), Vector3.all(1))
        .storage);

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
