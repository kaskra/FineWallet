import 'dart:math';

import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyExpenseChart extends StatelessWidget {
  final double radius;
  final double thickness;
  final Color backgroundColor;

  const MonthlyExpenseChart(
      {Key key, this.radius = 40, this.thickness = 5, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MonthWithDetails>(
        stream: Provider.of<AppDatabase>(context)
            .monthDao
            .watchCurrentMonthWithDetails(),
        builder: (context, snapshot) {
          double total = 0;
          double value = 0;

          if (snapshot.hasData) {
            total = snapshot.data.month.maxBudget +
                snapshot.data.month.savingsBudget;
            value = snapshot.data.expense;
          }

          if (snapshot.data == null) {
            Provider.of<AppDatabase>(context, listen: false)
                .monthDao
                .checkForCurrentMonth();
          }

          return CustomPaint(
            painter: MonthlyExpensePainter(
                backgroundColor: backgroundColor ?? Colors.transparent,
                activeColor: Theme.of(context).colorScheme.secondary,
                value: value,
                total: total,
                thickness: thickness),
            size: Size.fromRadius(radius),
            child: SizedBox(
              height: radius * 2,
              width: radius * 2,
              child: Center(
                  child: Padding(
                padding: EdgeInsets.all(thickness * 1.5),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "${value.toStringAsFixed(2)} /\n"
                    "${total.toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).userCurrency}",
                    maxLines: 2,
                    softWrap: true,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              )),
            ),
          );
        });
  }
}

class MonthlyExpensePainter extends CustomPainter {
  final double value;
  final double total;
  final Color backgroundColor;
  final Color inactiveColor;
  final Color activeColor;
  final double thickness;

  MonthlyExpensePainter({
    this.thickness = 10,
    this.backgroundColor = Colors.transparent,
    this.inactiveColor = Colors.grey,
    this.activeColor = Colors.red,
    @required this.value,
    @required this.total,
  });

  final double _maxValue = 270;

  double calcArcValue() {
    final ratio = (value / total).clamp(0, 1).toDouble();
    final arcValue = _maxValue * ratio;
    return _maxValue - arcValue;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paintActive = Paint()..color = activeColor;
    final paintInactive = Paint()..color = inactiveColor;
    final paintBackground = Paint()..color = backgroundColor;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    _drawArc(canvas, rect, _maxValue, paintActive);
    _drawArc(canvas, rect, calcArcValue(), paintInactive);
    canvas.drawCircle(
        rect.center, (size.height / 2) - thickness, paintBackground);
  }

  void _drawArc(Canvas canvas, Rect rect, double value, Paint paint) {
    canvas.drawArc(rect, deg2rad(-45), deg2rad(value), true, paint);
  }

  double deg2rad(double deg) {
    return -(deg / 180) * pi;
  }

  @override
  bool shouldRepaint(MonthlyExpensePainter oldDelegate) {
    return false;
  }

  @override
  bool shouldRebuildSemantics(MonthlyExpensePainter oldDelegate) {
    return false;
  }
}
