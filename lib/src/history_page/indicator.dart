import 'package:flutter/material.dart';

class IndicatorPainter extends CustomPainter {
  final Color color;
  final double thickness;

  IndicatorPainter({
    this.color,
    double thickness,
  }) : this.thickness = thickness ?? 6;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;

    Rect rect = Rect.fromLTWH(0, 0, thickness, size.height);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
