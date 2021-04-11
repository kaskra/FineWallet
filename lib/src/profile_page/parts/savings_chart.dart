import 'dart:math';

import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavingsChart extends StatelessWidget {
  const SavingsChart({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return StreamBuilder<List<SavingsPerMonth>>(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchSavingsPerMonth(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return LineChart(mainData(context, snapshot.data));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  LineChartData mainData(BuildContext context, List<SavingsPerMonth> data) {
    final colors = [Theme.of(context).accentColor];
    final formatter = DateFormat("MMM yy", context.locale.toLanguageTag());
    final singleMonth = data.length == 1;

    if (singleMonth) {
      data.add(data.first);
    }

    final dates = data.map((e) => e.m.firstDate).toList();

    final chartData = List.generate(
        data.length, (i) => FlSpot(i.toDouble(), data[i].savings));

    final minX = chartData.first.x;
    final maxX = chartData.last.x;

    var maxY =
        chartData.map((e) => e.y).fold(0.0, (double p, e) => (p > e) ? p : e);
    maxY += maxY / 10;
    if (maxY == 0) maxY = 100;

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
          spots: chartData,
          colors: colors,
          barWidth: 3,
          dotData: FlDotData(show: false),
          colorStops: [0, 1],
          gradientFrom: const Offset(0.0, 1.0),
          gradientTo: const Offset(1.0, 0.0),
          belowBarData: BarAreaData(
            show: true,
            colors: colors.map((color) => color.withOpacity(0.1)).toList(),
            gradientColorStops: [0, 1],
            gradientFrom: const Offset(0.0, 1.0),
            gradientTo: const Offset(1.0, 0.0),
          ),
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
          rotateAngle: 60,
          interval: (maxX + 1) / min(dates.length, 10),
          getTitles: (value) {
            return formatter.format(dates[value.toInt()]);
          },
          checkToShowTitle: (minValue, maxValue, __, ___, value) {
            if (value == minValue && singleMonth) return false;
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
}
