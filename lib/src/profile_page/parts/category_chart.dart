/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:19:59 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/datatypes/tuple.dart';
import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:supercharged/supercharged.dart';

class CategoryChart extends StatefulWidget {
  const CategoryChart({this.type = monthlyChart, this.filterSettings});

  static const int lifeChart = 2;
  static const int monthlyChart = 1;

  final int type;
  final TransactionFilterSettings filterSettings;

  @override
  _CategoryChartState createState() => _CategoryChartState();
}

class _CategoryChartState extends State<CategoryChart> {
  /// Returns a [StreamBuilder] that displays a chart with expenses per category.
  ///
  /// Return
  /// -----
  /// [AsyncSnapshot] of [Tuple3]s with category id, category name and
  /// expense per category.
  StreamBuilder<List<SumTransactionsByCategoryResult>> _buildChartWithData() {
    // Check which chart should be displayed and load the correct data for it.
    TransactionFilterSettings settings;
    if (widget.type == CategoryChart.monthlyChart) {
      settings = widget.filterSettings ??
          TransactionFilterSettings(
            dateInMonth: today(),
            expenses: true,
          );
    } else {
      settings =
          widget.filterSettings ?? TransactionFilterSettings(expenses: true);
    }

    return StreamBuilder<List<SumTransactionsByCategoryResult>>(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchSumOfTransactionsByCategories(settings),
      builder: (context, transactionSnapshot) {
        return _buildChart(transactionSnapshot);
      },
    );
  }

  /// Builds the [CircularProfileChart] to display the expenses per
  /// category with names.
  ///
  /// Input
  /// -----
  /// [AsyncSnapshot] of [SumTransactionsByCategoryResult]s with category and
  /// expense per category.
  ///
  /// Return
  /// ------
  /// Resulting [CircularProfileChart].
  Widget _buildChart(
      AsyncSnapshot<List<SumTransactionsByCategoryResult>>
          transactionSnapshot) {
    if (transactionSnapshot.hasData) {
      if (transactionSnapshot.data.isEmpty) {
        return Center(child: Text(LocaleKeys.profile_page_no_expenses.tr()));
      }

      // Get the summed up expenses, ids and names for each category.
      final ids = transactionSnapshot.data.map((l) => l.c.id).toList();
      final names =
          transactionSnapshot.data.map((l) => tryTranslatePreset(l.c)).toList();
      final expenses =
          transactionSnapshot.data.map((l) => l.sumAmount).toList();
      final icons =
          transactionSnapshot.data.map((e) => e.c.iconCodePoint).toList();

      // Create the chart with expenses per category and category names.
      return CircularCategoryChart(
          amounts: expenses, names: names, ids: ids, iconCodePoints: icons);
    }
    return Center(child: Text(LocaleKeys.profile_page_no_expenses.tr()));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _buildChartWithData(),
    );
  }
}

/// The actual chart
class CircularCategoryChart extends StatefulWidget {
  final List<double> amounts;
  final List<String> names;
  final List<int> ids;
  final List<int> iconCodePoints;

  const CircularCategoryChart(
      {Key key,
      @required this.amounts,
      @required this.names,
      @required this.ids,
      @required this.iconCodePoints})
      : assert(amounts != null),
        assert(names != null),
        assert(ids != null),
        assert(iconCodePoints != null),
        super(key: key);

  @override
  _CircularCategoryChartState createState() => _CircularCategoryChartState();
}

class _CircularCategoryChartState extends State<CircularCategoryChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          sections: _pieChartSections(context),
          centerSpaceRadius: 30,
          sectionsSpace: 1,
          pieTouchData: PieTouchData(
            enabled: true,
            touchCallback: (touch) {
              setState(() {
                final desiredTouch = touch.touchInput is! PointerExitEvent &&
                    touch.touchInput is! PointerUpEvent;
                if (desiredTouch && touch.touchedSection != null) {
                  _touchedIndex = touch.touchedSection.touchedSectionIndex;
                } else {
                  _touchedIndex = -1;
                }
              });
            },
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _pieChartSections(BuildContext context) {
    final accentHue =
        HSLColor.fromColor(Theme.of(context).accentColor).hue.toInt();
    final colorHue = ColorHue.custom(Range(accentHue - 10, accentHue + 10));

    final totalAmount = widget.amounts.sumByDouble((n) => n);

    return List.generate(widget.amounts.length, (index) {
      final bool isTouched = _touchedIndex == index;
      final double opacity = isTouched || _touchedIndex == -1 ? 1 : 0.6;

      final RandomColor _randomColor = RandomColor(widget.ids[index]);
      final color = _randomColor.randomColor(
        colorBrightness: ColorBrightness.light,
        colorHue: colorHue,
      );

      final textColor =
          color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

      return PieChartSectionData(
          showTitle: widget.amounts[index] / totalAmount > 0.07,
          value: widget.amounts[index],
          title: "${(widget.amounts[index] / totalAmount * 100).round()}%",
          color: color.withOpacity(opacity),
          radius: isTouched ? 55 : 45,
          titleStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: textColor.withOpacity(opacity),
          ),
          badgeWidget: isTouched
              ? Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                          IconData(widget.iconCodePoints[index],
                              fontFamily: 'MaterialIcons'),
                          color: textColor),
                      const SizedBox(width: 8),
                      Text(
                        "${(widget.amounts[index] / totalAmount * 100).round()}%"
                        "\n${widget.names[index]}",
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                )
              : null);
    });
  }
}
