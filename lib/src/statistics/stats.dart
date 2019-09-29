/*
 * Project: FineWallet
 * Last Modified: Sunday, 29th September 2019 12:27:42 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/models/month_model.dart';
import 'package:FineWallet/core/resources/blocs/month_bloc.dart';
import 'package:FineWallet/core/resources/transaction_list.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key key}) : super(key: key);

  // TODO if needed, add page controller
  @override
  Widget build(BuildContext context) {
    return Consumer<MonthBloc>(
      builder: (context, bloc, child) {
        bloc.getMonths();
        return StreamBuilder<List<MonthModel>>(
          stream: bloc.allMonths,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.hasData
                ? PageView(
                    pageSnapping: true,
                    onPageChanged: (pageIndex) {
                      print(pageIndex);
                    },
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    children: <Widget>[
                      for (MonthModel m in snapshot.data)
                        MonthCard(
                          context: context,
                          transactions: TransactionList(),
                          model: m,
                        )
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        );
      },
    );
  }
}

class MonthCard extends StatelessWidget {
  final TransactionList transactions;
  final BuildContext context;
  final MonthModel model;
  final DateTime date;

  MonthCard(
      {Key key,
      this.context,
      @required this.transactions,
      @required this.model})
      : this.date = DateTime.fromMillisecondsSinceEpoch(model.firstDayOfMonth),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandToScreenRatio(
      widthRatio: 1,
      heightRatio: 1,
      margin: const EdgeInsets.all(5),
      child: Stack(
        children: <Widget>[
          DecoratedCard(
            borderColor: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
            borderWidth: 0,
            child: _buildContent(),
          ),
          _buildYearNumber(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: <Widget>[
        _buildTitle(),
        _buildRest(),
      ],
    );
  }

  Widget _buildTitle() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "${getMonthName(date.month)}",
            style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildYearNumber() {
    return Positioned(
      top: 5,
      right: 5,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.onSurface,
              width: 0,
            ),
            left: BorderSide(
                color: Theme.of(context).colorScheme.onSurface, width: 0),
          ),
        ),
        child: Text(
          "${date.year}",
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary, fontSize: 22),
        ),
      ),
    );
  }

  Widget _buildRest() {
    return Container(
      child: Text("\n " +
          date.toIso8601String() +
          "\n Current max budget: " +
          model.currentMaxBudget.toStringAsFixed(2) +
          "\n Savings: " +
          model.savings.toStringAsFixed(2) +
          "\n Monthly expenses: " +
          model.monthlyExpenses.toStringAsFixed(2)),
    );
  }
}
