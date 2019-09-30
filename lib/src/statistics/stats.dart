/*
 * Project: FineWallet
 * Last Modified: Sunday, 29th September 2019 12:27:42 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/models/month_model.dart';
import 'package:FineWallet/core/resources/blocs/month_bloc.dart';
import 'package:FineWallet/core/resources/transaction_list.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
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
        _buildIncomeExpense(),
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
      top: 4,
      right: 4,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          border: Border(
            bottom: BorderSide(
              color: Colors.black38,
              width: 0,
            ),
            left: BorderSide(color: Colors.black38, width: 0),
          ),
        ),
        child: Text(
          "${date.year}",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary, fontSize: 22),
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

  Widget _buildIncomeExpense() {
    double firstPart = 0;
    if (model.currentMaxBudget != 0) {
      firstPart = model.monthlyExpenses / model.currentMaxBudget * 100;
    }

    Color backgroundColor =
        model.monthlyExpenses > 0 && model.currentMaxBudget == 0
            ? Colors.redAccent
            : Colors.black.withOpacity(0.05);
    Color progressColor = model.monthlyExpenses > model.currentMaxBudget
        ? Colors.redAccent
        : Theme.of(context).colorScheme.secondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
      child: RoundedProgressBar(
        style: RoundedProgressBarStyle(
            borderWidth: 0,
            widthShadow: 0,
            colorProgress: progressColor,
            colorProgressDark: progressColor,
            backgroundProgress: backgroundColor),
        percent: firstPart,
        height: 25,
        childCenter: Text(
            "${model.monthlyExpenses.toStringAsFixed(2)} / ${model.currentMaxBudget.toStringAsFixed(2)} €", style: TextStyle(fontWeight: FontWeight.bold),),
        borderRadius: BorderRadius.circular(CARD_RADIUS),
      ),
    );
  }
}
