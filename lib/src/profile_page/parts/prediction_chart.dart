import 'dart:math';

import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PredictionChart extends StatelessWidget {
  final double monthlyBudget;

  const PredictionChart({Key key, this.monthlyBudget = 0}) : super(key: key);

  Widget build(BuildContext context) {
    return StreamBuilder<List<ExpensesPerDayInMonthResult>>(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchExpensesPerDayInMonth(today()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return LineChart(mainData(context, snapshot.data));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  LineChartData mainData(
      BuildContext context, List<ExpensesPerDayInMonthResult> data) {
    const minX = 1.0;

    final gradients = [Colors.red, Colors.green];

    final chartData = _calcDateTimeDataPoints(data);
    final before = chartData.takeWhile((v) => v.x <= today().day).toList();
    final after = chartData.skipWhile((v) => v.x < today().day).toList();
    final stopIndex = chartData.indexWhere((e) => e.y >= monthlyBudget);

    final maxX = today().getLastDateOfMonth().day.toDouble();

    var maxY =
        chartData.map((e) => e.y).fold(0.0, (double p, e) => (p > e) ? p : e);
    maxY = max(maxY, monthlyBudget);
    maxY += maxY / 10;

    final stop = stopIndex == -1 ? 1.0 : stopIndex / maxX;

    final niceRange = NiceTicks(maxTicks: 6, minPoint: 0, maxPoint: maxY);

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(color: const Color(0xff37434d), strokeWidth: 0.1);
        },
      ),
      minX: minX,
      maxX: maxX,
      minY: niceRange.niceMin,
      maxY: niceRange.niceMax,
      lineTouchData: LineTouchData(enabled: false),
      lineBarsData: [
        LineChartBarData(
          spots: before,
          colors: gradients,
          barWidth: 3,
          dotData: FlDotData(show: false),
          colorStops: [stop, stop],
          gradientFrom: const Offset(0.0, 1.0),
          gradientTo: const Offset(1.0, 0.0),
          belowBarData: BarAreaData(
            show: true,
            colors: gradients.map((color) => color.withOpacity(0.3)).toList(),
            gradientColorStops: [stop, stop],
            gradientFrom: const Offset(0.0, 0.0),
            gradientTo: const Offset(1.0, 0.0),
          ),
        ),
        LineChartBarData(
          spots: after,
          dashArray: [4, 4],
          colors: gradients,
          barWidth: 2,
          dotData: FlDotData(show: false),
          colorStops: [stop, stop],
          gradientFrom: const Offset(0.0, 1.0),
          gradientTo: const Offset(1.0, 0.0),
          belowBarData: BarAreaData(
            show: true,
            colors: gradients.map((color) => color.withOpacity(0.3)).toList(),
            gradientColorStops: [stop, stop],
            gradientFrom: const Offset(0.0, 0.0),
            gradientTo: const Offset(1.0, 0.0),
          ),
        ),
        LineChartBarData(
          spots: [
            FlSpot(minX, monthlyBudget),
            FlSpot(maxX, monthlyBudget),
          ],
          colors: [Colors.red],
          barWidth: 1.5,
          shadow: const Shadow(),
          dotData: FlDotData(show: false),
        ),
      ],
      titlesData: FlTitlesData(
        leftTitles: SideTitles(
          showTitles: true,
          interval: niceRange.tickSpacing,
          getTitles: (value) {
            final v = value.toInt();
            return v.toString();
          },
          getTextStyles: (value) => TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 11,
          ),
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          interval: maxX / 10,
          getTitles: (value) {
            final v = value.toInt();
            return v.toString();
          },
          checkToShowTitle: (_, maxValue, __, ___, value) {
            if (value == maxValue) return true;
            return true;
          },
          getTextStyles: (value) => TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 11,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(bottom: BorderSide()),
      ),
    );
  }

  List<FlSpot> _calcDateTimeDataPoints(List<ExpensesPerDayInMonthResult> data) {
    final List<DateTime> days = getListOfMonthDays(today());

    List<double> expense = _computeExpensesPerDay(days, data);
    expense = _computePrediction(days, expense);
    return _generateChartPoints(days, expense);
  }

  List<double> _computeExpensesPerDay(
      List<DateTime> days, List<ExpensesPerDayInMonthResult> data) {
    // Calc the step function by using all expenses of every day in the month
    double prev = 0;

    final List<double> expense = days.map((date) {
      final txs = data
          .where((t) => DateTime.parse(t.date).isAtSameMomentAs(date))
          .toList();
      // If there are expense transactions on that day, return the amount.
      if (txs.isNotEmpty) return txs.first.expense;
      // Otherwise Zero.
      return 0.0;
    }).map((double d) {
      // Set each next day as previous day + amount of day.
      return prev += d;
    }).toList();

    return expense;
  }

  List<FlSpot> _generateChartPoints(List<DateTime> days, List<double> expense) {
    final List<FlSpot> dataPoints = [];
    for (int i = 0; i < days.length; i++) {
      dataPoints.add(FlSpot(days[i].day.toDouble(), expense[i]));
    }
    return dataPoints;
  }

  /// Go over the expenses and add a prediction for future days.
  List<double> _computePrediction(List<DateTime> days, List<double> expense) {
    final List<double> resultingExpenses = expense;
    // Go over the expenses and add a prediction for future days.
    double gradient = 0;
    bool isToday = true;
    int todayIdx = 0;
    for (int i = 0; i < days.length; i++) {
      // Once the days are after the current date, the values are a prediction
      if (days[i].isAfter(today())) {
        if (isToday) {
          // expense[i] is the sum of all expenses up to day i
          gradient = resultingExpenses[i] / (i + 1);
          isToday = false;
          todayIdx = i;
        }
        if (i > 0) {
          resultingExpenses[i] += gradient * (i - todayIdx);
        }
      }
    }
    return resultingExpenses;
  }
}
