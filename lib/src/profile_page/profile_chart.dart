/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:19:59 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/resources/blocs/category_bloc.dart';
import 'package:FineWallet/core/resources/blocs/transaction_bloc.dart';
import 'package:FineWallet/core/resources/category_list.dart';
import 'package:FineWallet/core/resources/transaction_list.dart';
import 'package:FineWallet/src/statistics/chart_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileChart extends StatefulWidget {
  ProfileChart({this.type = MONTHLY_CHART});

  static const int LIFE_CHART = 2;
  static const int MONTHLY_CHART = 1;

  final int type;

  @override
  _ProfileChartState createState() => _ProfileChartState();
}

class _ProfileChartState extends State<ProfileChart> {
  StreamBuilder<CategoryList> _addCategories(
      CategoryBloc categoryBloc, TransactionBloc transactionBloc) {
    return StreamBuilder<CategoryList>(
      stream: categoryBloc.allCategories,
      builder: (context, AsyncSnapshot<CategoryList> categorySnapshot) {
        if (categorySnapshot.hasData) {
          return _addTransactions(transactionBloc, categorySnapshot);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  StreamBuilder<TransactionList> _addTransactions(
      TransactionBloc bloc, AsyncSnapshot<CategoryList> categorySnapshot) {
    // Check which chart should be displayed and load the correct data for it.
    if (widget.type == ProfileChart.MONTHLY_CHART) {
      bloc.getMonthlyTransactions();
    } else {
      bloc.getAllTransactions();
    }

    return StreamBuilder<TransactionList>(
      stream: widget.type == ProfileChart.MONTHLY_CHART
          ? bloc.monthlyTransactions
          : bloc.allTransactions,
      builder: (context, AsyncSnapshot<TransactionList> transactionSnapshot) {
        return _buildChart(transactionSnapshot, categorySnapshot);
      },
    );
  }

  Widget _buildChart(AsyncSnapshot<TransactionList> transactionSnapshot,
      AsyncSnapshot<CategoryList> categorySnapshot) {
    if (transactionSnapshot.hasData && categorySnapshot.data.ids() != null) {
      // Get the summed up expenses for each category.
      List<double> expenses = [
        for (int c in categorySnapshot.data.ids())
          transactionSnapshot.data.byCategory(c).sumExpenses()
      ];

      // Create the chart with expenses per category and category names.
      return CircularProfileChart.withTransactions(
          expenses, categorySnapshot.data.ids(), categorySnapshot.data.names());
    }
    return Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Consumer2<TransactionBloc, CategoryBloc>(
          builder: (_, transactionBloc, categoryBloc, child) {
            categoryBloc.getCategories(true);
            return _addCategories(categoryBloc, transactionBloc);
          },
        ),
      ),
    );
  }
}

class CircularProfileChart extends StatelessWidget {
  CircularProfileChart(this.seriesList, {this.animate});

  factory CircularProfileChart.withTransactions(
      List<double> expenses, List<int> categories, List<String> categoryNames) {
    List<CategoryExpenses> inputData = [];
    for (int i = 0; i < expenses.length; i++) {
      if (expenses[i] > 0)
        inputData.add(
            CategoryExpenses(expenses[i], categories[i], categoryNames[i]));
    }

    List<charts.Series<CategoryExpenses, int>> data = [];
    if (inputData.length > 0) {
      data = [
        charts.Series<CategoryExpenses, int>(
            data: inputData,
            id: "CategoryExpenses",
            domainFn: (CategoryExpenses ce, _) => ce.categoryId,
            measureFn: (CategoryExpenses ce, _) => ce.amount,
            labelAccessorFn: (CategoryExpenses ce, _) => ce.categoryName,
            colorFn: (CategoryExpenses ce, int i) => charts
                .MaterialPalette.deepOrange
                .makeShades(categories.length)[i])
      ];
    } else {
      data = [
        charts.Series<CategoryExpenses, int>(
            data: [CategoryExpenses(0, 0, "0")],
            id: "CategoryExpenses",
            domainFn: (CategoryExpenses ce, _) => 0,
            measureFn: (CategoryExpenses ce, _) => 1,
            labelAccessorFn: (CategoryExpenses ce, _) => "",
            colorFn: (CategoryExpenses ce, int i) =>
                charts.MaterialPalette.gray.shade200)
      ];
    }
    return CircularProfileChart(
      data,
      animate: false,
    );
  }

  final bool animate;
  final List<charts.Series> seriesList;

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: animate,
      defaultInteractions: true,
      defaultRenderer: new charts.ArcRendererConfig(
        arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              leaderLineStyleSpec: charts.ArcLabelLeaderLineStyleSpec(
                  length: 10, color: charts.Color.black, thickness: 1),
              showLeaderLines: true,
              outsideLabelStyleSpec: charts.TextStyleSpec(fontSize: 12),
              labelPosition: charts.ArcLabelPosition.outside),
        ],
        arcWidth: 25,
      ),
    );
  }
}
