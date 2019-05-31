import 'dart:math';

import 'package:flutter/material.dart';

class LineChart extends StatefulWidget {
  LineChart({@required this.data, @required this.lineColor});

  final List<double> data;
  final Color lineColor;

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black12,
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black12, width: 1)),
      child: CustomPaint(
        painter: LineChartPainter(
            data: widget.data ?? List(),
            color: widget.lineColor ?? Colors.black),
        child: Container(
          height: 120,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  List<double> indices;
  List<double> data;
  final Color color;

  final int upperSpace = 20;

  LineChartPainter({this.data, this.color}) {
    indices = List.generate(data.length, (int index) => index.toDouble());
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length <= 0) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final height = size.height;
    final width = size.width;
    Path path = Path();

    final maxDataValue =
        data.fold(0.0, (prev, next) => max<double>(prev, next)) + upperSpace;
    final xMargin = width ~/ data.length;
    final yMargin = height / maxDataValue;

    data = data.map((d) => (d - maxDataValue).abs()).toList();

    double y = data[0] * yMargin;
    path.moveTo(indices[0], y);

    for (var i = 0; i < data.length; i++) {
      y = data[i];
      path.lineTo(indices[i] * xMargin, y * yMargin);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(LineChartPainter oldDelegate) => false;
}

class BarChart extends StatefulWidget {
  BarChart({@required this.data, @required this.barColor});

  final List<double> data;
  final Color barColor;

  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black12,
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black12, width: 1)),
      child: CustomPaint(
        painter: BarChartPainter(
            data: widget.data ?? List(),
            color: widget.barColor ?? Colors.black),
        child: Container(
          height: 120,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  List<double> indices;
  List<double> data;
  final Color color;

  final int upperSpace = 20;

  BarChartPainter({this.data, this.color}) {
    indices = List.generate(data.length, (int index) => index.toDouble());
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length <= 0) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final height = size.height;
    final width = size.width;

    final maxDataValue =
        data.fold(0.0, (prev, next) => max<double>(prev, next)) + upperSpace;
    final xMargin = width ~/ data.length;
    final yMargin = height / maxDataValue;

    // data = data.map((d) => (d - maxDataValue).abs()).toList();

    for (var i = 0; i < data.length; i++) {
      Path path = Path();
      path.moveTo(indices[i] * xMargin, height);
      path.lineTo(indices[i] * xMargin, height - data[i] * yMargin);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(BarChartPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BarChartPainter oldDelegate) => false;
}
