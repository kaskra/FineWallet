/*
 * Project: FineWallet
 * Last Modified: Monday, 23rd September 2019 9:12:00 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Timeline extends StatelessWidget {
  const Timeline(
      {Key key,
      this.items,
      this.color = Colors.grey,
      this.selectionColor = Colors.black})
      : super(key: key);

  final Color color;
  final List<Widget> items;
  final Color selectionColor;

  Widget _buildTimelineItem(int index, Widget item, int childCount) {
    return CustomPaint(
      painter: TimelinePainter(
          index: index,
          childCount: childCount,
          gradientColors: [selectionColor, color],
          color: color),
      child: Padding(
        padding: const EdgeInsets.only(left: 25),
        child: item,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        for (int i = 0; i < items.length; i++)
          _buildTimelineItem(i, items[i], items.length)
      ],
    );
  }
}

class TimelinePainter extends CustomPainter {
  const TimelinePainter({
    @required this.index,
    @required this.childCount,
    this.dotRadius = 6,
    this.color = Colors.grey,
    this.strokeWidth = 2,
    this.gradientColors,
    this.offsetLeft = 10,
  });

  final int childCount;
  final Color color;
  final double dotRadius;
  final List<Color> gradientColors;
  final int index;
  final double offsetLeft;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;

    final heightCenter = size.height / 2;

    if (index == 0 && gradientColors != null) {
      paint
        ..style = PaintingStyle.fill
        ..shader = ui.Gradient.linear(const Offset(0.0, 0.0),
            Offset(0.0, size.height), gradientColors, [0.8, 1]);
    }

    canvas.drawCircle(Offset(offsetLeft, heightCenter), dotRadius, paint);

    if (index > 0) {
      canvas.drawLine(Offset(offsetLeft, 0),
          Offset(offsetLeft, heightCenter - dotRadius - 2), paint);
    }

    if (index < childCount - 1) {
      canvas.drawLine(Offset(offsetLeft, heightCenter + dotRadius + 2),
          Offset(offsetLeft, size.height), paint);
    }
  }

  @override
  bool shouldRebuildSemantics(TimelinePainter oldDelegate) => false;

  @override
  bool shouldRepaint(TimelinePainter oldDelegate) => false;
}
