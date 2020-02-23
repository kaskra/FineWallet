import 'package:flutter/material.dart';

enum IndicatorSide { left, right }

class IndicatorPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final IndicatorSide side;

  IndicatorPainter({
    IndicatorSide side,
    this.color,
    double thickness,
  })  : thickness = thickness ?? 6,
        side = side ?? IndicatorSide.left;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final double startX =
        side == IndicatorSide.left ? 0 : size.width - thickness;

    final rect = Rect.fromLTWH(startX, 0, thickness, size.height);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
