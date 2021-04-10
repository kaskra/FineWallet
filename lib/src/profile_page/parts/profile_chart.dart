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
import 'package:FineWallet/src/profile_page/parts/circular_category_chart.dart';
import 'package:FineWallet/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      final names = transactionSnapshot.data
          .map((l) => tryTranslatePreset(l.c.name))
          .toList();
      final expenses =
          transactionSnapshot.data.map((l) => l.sumAmount).toList();

      // Create the chart with expenses per category and category names.
      return CircularCategoryChart(amounts: expenses, names: names, ids: ids);
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
