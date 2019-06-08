/*
 * Developed by Lukas Krauch 8.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:flutter/material.dart';

class CornerTriangle extends StatelessWidget {
  const CornerTriangle(
      {Key key,
      @required this.child,
      @required this.size,
      this.icon,
      this.color})
      : super(key: key);

  final Size size;
  final Widget child;
  final Widget icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomPaint(
          painter: CornerTrianglePainter(triangleSize: size, color: color),
          child: child,
        ),
        Container(
          padding: EdgeInsets.all(1),
          alignment: Alignment(-1, -1),
          child: icon,
        )
      ],
    );
  }
}

class CornerTrianglePainter extends CustomPainter {
  const CornerTrianglePainter({@required this.triangleSize, this.color});

  final Color color;
  final Size triangleSize;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = color;
    var triangle = Path();
    triangle.lineTo(0, triangleSize.width);
    triangle.lineTo(triangleSize.height, 0);
    triangle.close();

    canvas.drawPath(triangle, paint);
  }

  @override
  bool shouldRepaint(CornerTrianglePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CornerTrianglePainter oldDelegate) => false;
}
