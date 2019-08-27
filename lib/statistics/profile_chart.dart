/*
 * Developed by Lukas Krauch 10.7.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:FineWallet/models/category_model.dart';
import 'package:FineWallet/models/transaction_model.dart';
import 'package:FineWallet/resources/blocs/transaction_bloc.dart';
import 'package:FineWallet/resources/category_list.dart';
import 'package:FineWallet/resources/category_provider.dart';
import 'package:FineWallet/resources/transaction_list.dart';
import 'package:FineWallet/statistics/chart_data.dart';
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
  List<int> categories;
  List<String> categoryNames;
  DateTime today;

  @override
  void initState() {
    super.initState();
    _getCategories();
    DateTime now = DateTime.now();
    setState(() {
      today = DateTime.utc(now.year, now.month, now.day);
    });
  }

  void _getCategories() async {
    CategoryList cate =
        await CategoryProvider.db.getAllCategories(isExpense: true);
    setState(() {
      categories = cate.map((CategoryModel category) => category.id).toList();
      categoryNames =
          cate.map((CategoryModel category) => category.name).toList();
    });
  }

  Widget _buildChart() {
    return Consumer<TransactionBloc>(
      builder: (_, bloc, child) {
        Stream stream;
        if (widget.type == ProfileChart.MONTHLY_CHART) {
          bloc.getMonthlyTransactions();
          stream = bloc.monthlyTransactions;
        } else {
          bloc.getAllTransactions();
          stream = bloc.allTransactions;
        }

        return StreamBuilder<TransactionList>(
          stream: stream,
          builder: (context, AsyncSnapshot<TransactionList> snapshot) {
            if (snapshot.hasData && categories != null) {
              List<double> expenses = [];
              for (int c in categories) {
                double ex = snapshot.data
                    .where((TransactionModel tx) => tx.category == c)
                    .sumExpenses();
                expenses.add(ex);
              }
              return CircularProfileChart.withTransactions(
                  expenses, categories, categoryNames);
            }
            return Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: _buildChart(),
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
