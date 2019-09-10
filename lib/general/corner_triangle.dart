/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:16:01 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Corner {
  TOP_LEFT,
  TOP_RIGHT,
  BOTTOM_LEFT,
  BOTTOM_RIGHT,
}

class CornerIcon {
  CornerIcon(this.data, {this.color = Colors.black});

  final IconData data;
  final Color color;
}

class CornerTriangle extends StatelessWidget {
  const CornerTriangle(
      {Key key,
      @required this.child,
      @required this.size,
      @required this.corner,
      this.borderRadius = const Radius.circular(4),
      this.icon,
      this.color = Colors.red})
      : super(key: key);

  final Size size;
  final Widget child;
  final Corner corner;
  final Radius borderRadius;
  final CornerIcon icon;
  final Color color;

  BorderRadius _getBorderRadiusFromCorner() {
    assert(corner != null);
    switch (corner) {
      case Corner.TOP_LEFT:
        return BorderRadius.only(topLeft: borderRadius);
        break;
      case Corner.TOP_RIGHT:
        return BorderRadius.only(topRight: borderRadius);
        break;
      case Corner.BOTTOM_LEFT:
        return BorderRadius.only(bottomLeft: borderRadius);
        break;
      case Corner.BOTTOM_RIGHT:
        return BorderRadius.only(bottomRight: borderRadius);
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Alignment iconAlignment =
        (corner == Corner.TOP_LEFT || corner == Corner.TOP_RIGHT)
            ? Alignment.topCenter
            : Alignment.bottomCenter;
    double iconSide =
        (corner == Corner.BOTTOM_LEFT || corner == Corner.TOP_LEFT) ? -1 : 1;

    double triangleLongestSide =
        sqrt(size.width * size.width + size.height * size.height);
    double triangleHeight =
        (size.width * size.height) / triangleLongestSide - sqrt2;
    double iconRectSize = sqrt(pow(triangleHeight, 2) / 2);

    return ClipRRect(
      borderRadius: _getBorderRadiusFromCorner(),
      child: Stack(
        alignment: iconAlignment,
        children: <Widget>[
          CustomPaint(
            painter: CornerTrianglePainter(
                triangleSize: size, corner: corner, color: color),
            child: child,
          ),
          Container(
            padding: const EdgeInsets.all(2),
            alignment: Alignment(iconSide, -1),
            child: Icon(
              icon.data,
              color: icon.color,
              size: iconRectSize,
            ),
          ),
        ],
      ),
    );
  }
}

class CornerTrianglePainter extends CustomPainter {
  const CornerTrianglePainter(
      {@required this.triangleSize, @required this.corner, this.color});

  final Color color;
  final Size triangleSize;
  final Corner corner;

  Offset _getOffset(Size size) {
    switch (corner) {
      case Corner.TOP_LEFT:
        return Offset(0, 0);
        break;
      case Corner.TOP_RIGHT:
        return Offset(size.width, 0);
        break;
      case Corner.BOTTOM_LEFT:
        return Offset(0, size.height);
        break;
      case Corner.BOTTOM_RIGHT:
        return Offset(size.width, size.height);
        break;
    }
    return Offset(0, 0);
  }

  List<double> _getFirstPoint(Offset offset) {
    List<double> res = [];
    if (corner == Corner.TOP_LEFT || corner == Corner.TOP_RIGHT) {
      res.addAll([offset.dx, triangleSize.height]);
    } else if (corner == Corner.BOTTOM_LEFT || corner == Corner.BOTTOM_RIGHT) {
      res.addAll([offset.dx, offset.dy - triangleSize.height]);
    }
    assert(res.length == 2);
    return res;
  }

  List<double> _getSecondPoint(Offset offset) {
    List<double> res = [];
    switch (corner) {
      case Corner.TOP_LEFT:
        res.addAll([triangleSize.width, 0]);
        break;
      case Corner.TOP_RIGHT:
        res.addAll([offset.dx - triangleSize.width, 0]);
        break;
      case Corner.BOTTOM_LEFT:
        res.addAll([triangleSize.width, offset.dy]);
        break;
      case Corner.BOTTOM_RIGHT:
        res.addAll([offset.dx - triangleSize.width, offset.dy]);
        break;
    }
    assert(res.length == 2);
    return res;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    Offset offset = _getOffset(size);
    List<double> firstCoordinates = _getFirstPoint(offset);
    List<double> secondCoordinates = _getSecondPoint(offset);

    var triangle = Path();
    triangle.moveTo(offset.dx, offset.dy);
    triangle.lineTo(firstCoordinates[0], firstCoordinates[1]);
    triangle.lineTo(secondCoordinates[0], secondCoordinates[1]);
    triangle.close();

    canvas.drawPath(triangle, paint);
  }

  @override
  bool shouldRepaint(CornerTrianglePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CornerTrianglePainter oldDelegate) => false;
}
