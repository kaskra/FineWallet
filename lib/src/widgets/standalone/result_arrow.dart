import 'package:flutter/material.dart';

class ResultArrow extends StatelessWidget {
  final double radius;

  const ResultArrow({Key key, this.radius = 10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CombinationPainter(),
      size: Size.fromRadius(radius),
    );
  }
}

class CombinationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    const origin = Offset(0, 0);
    canvas.drawLine(size.centerLeft(origin), size.centerRight(origin), paint);
    canvas.drawLine(size.center(origin), size.bottomCenter(origin), paint);
  }

  @override
  bool shouldRepaint(CombinationPainter oldDelegate) {
    return true;
  }

  @override
  bool shouldRebuildSemantics(CombinationPainter oldDelegate) {
    return true;
  }
}
