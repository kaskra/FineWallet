import 'package:flutter/material.dart';

enum IndicatorSide { LEFT, RIGHT }

class IndicatorPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final IndicatorSide side;

  IndicatorPainter({
    IndicatorSide side,
    this.color,
    double thickness,
  })  : this.thickness = thickness ?? 6,
        this.side = side ?? IndicatorSide.LEFT;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;

    double startX = side == IndicatorSide.LEFT ? 0 : size.width - thickness;

    Rect rect = Rect.fromLTWH(startX, 0, thickness, size.height);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
