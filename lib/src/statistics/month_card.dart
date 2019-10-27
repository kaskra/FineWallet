/*
 * Project: FineWallet
 * Last Modified: Monday, 30th September 2019 4:54:04 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/models/month_model.dart';
import 'package:FineWallet/core/resources/blocs/category_bloc.dart';
import 'package:FineWallet/core/resources/blocs/transaction_bloc.dart';
import 'package:FineWallet/core/resources/category_icon.dart';
import 'package:FineWallet/core/resources/category_list.dart';
import 'package:FineWallet/core/resources/transaction_list.dart';
import 'package:FineWallet/src/history_page/history_item_icon.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:provider/provider.dart';

class MonthCard extends StatelessWidget {
  final BuildContext context;
  final MonthModel model;
  final DateTime date;

  MonthCard({Key key, this.context, @required this.model})
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
        new UsedBudgetBar(model: model),
        Divider(),
        Expanded(
          child: CategoryListView(
            context: context,
            model: model,
          ),
          flex: 10,
        ),
        Divider(),
        Expanded(
          flex: 0,
          child: _buildSavings(),
        ),
        Spacer()
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

  Widget _buildSavings() {
    String prefix = "You saved";
    if (date.month == DateTime.now().month &&
        date.year == DateTime.now().year) {
      prefix = "You will save";
    }

    return Text(
      "$prefix ${model.savings.toStringAsFixed(2)}€".toUpperCase(),
      style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.bold),
    );
  }
}

class UsedBudgetBar extends StatelessWidget {
  const UsedBudgetBar({
    Key key,
    @required this.model,
  }) : super(key: key);

  final MonthModel model;

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.fromLTRB(
        10.0,
        15.0,
        10.0,
        0.0,
      ),
      child: Column(
        children: <Widget>[
          RoundedProgressBar(
            style: RoundedProgressBarStyle(
              borderWidth: 0,
              widthShadow: 0,
              colorProgress: progressColor,
              colorProgressDark: progressColor,
              backgroundProgress: backgroundColor,
            ),
            percent: firstPart,
            height: 25,
            childCenter: Text(
              "${model.monthlyExpenses.toStringAsFixed(2)} / ${model.currentMaxBudget.toStringAsFixed(2)} €",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            borderRadius: BorderRadius.circular(CARD_RADIUS),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              "Used budget",
              style: TextStyle(
                  fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryListView extends StatelessWidget {
  final DateTime date;
  final MonthModel model;
  final BuildContext context;

  CategoryListView({Key key, @required this.model, @required this.context})
      : this.date = DateTime.fromMillisecondsSinceEpoch(model.firstDayOfMonth),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: _buildCategoryListView(), //Text("No categories found!"),
      ),
    );
  }

  Widget _buildCategoryListView() {
    return Consumer2<TransactionBloc, CategoryBloc>(
      builder: (context, txBloc, categoryBloc, child) {
        txBloc.getMonthlyTransactions(dateInMonth: model.firstDayOfMonth);
        return StreamBuilder<TransactionList>(
          stream: txBloc.monthlyTransactions,
          builder:
              (BuildContext context, AsyncSnapshot<TransactionList> snapshot) {
            if (snapshot.hasData) {
              List<int> ids = snapshot.data.expenses().getCategoryIds();

              Map<int, double> amounts = Map.fromEntries(ids.map((id) =>
                  MapEntry(id, snapshot.data.byCategory(id).sumExpenses())));

              categoryBloc.getCategories(true);
              return ListView(
                children: <Widget>[
                  for (int i = 0; i < amounts.length; i++)
                    _buildCategoryListItem(amounts.keys.elementAt(i),
                        amounts[amounts.keys.elementAt(i)], categoryBloc)
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        );
      },
    );
  }

  Widget _buildCategoryListItem(int id, double amount, CategoryBloc bloc) {
    return ListTile(
      leading: SizedBox(
        height: 50,
        width: 50,
        child: IconWrapper(
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(5),
            color: Theme.of(context).colorScheme.secondary,
            child: Icon(
              CategoryIcon(id - 1).data,
              color: Theme.of(context).colorScheme.onSecondary,
              size: 25,
            ),
          ),
        ),
      ),
      trailing: Text(
        "-${amount.toStringAsFixed(2)}€",
        style: TextStyle(
            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 17),
      ),
      title: StreamBuilder<CategoryList>(
          stream: bloc.allCategories,
          builder: (context, snapshot) {
            return Text(
              snapshot.hasData ? "${snapshot.data[id - 1].name}" : "---",
            );
          }),
    );
  }
}
