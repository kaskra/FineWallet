/*
 * Project: FineWallet
 * Last Modified: Monday, 30th September 2019 4:54:04 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/src/statistics/category_view.dart';
import 'package:FineWallet/src/statistics/used_budget_bar.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';

class MonthCard extends StatelessWidget {
  final BuildContext context;
  final MonthWithDetails model;
  final DateTime date;

  MonthCard({Key key, this.context, @required this.model})
      : this.date = DateTime.fromMillisecondsSinceEpoch(model.month.firstDate),
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
                color: Theme.of(context).colorScheme.onSecondary,
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
              color: Theme.of(context).colorScheme.onSurface, fontSize: 22),
        ),
      ),
    );
  }

  Widget _buildSavings() {
    String prefix = "You have saved";
    if (date.month == DateTime.now().month &&
        date.year == DateTime.now().year) {
      prefix = "You will save";
    }

    return FittedBox(
      fit: BoxFit.contain,
      child: Text(
        "$prefix ${model.savings.toStringAsFixed(2)}€".toUpperCase(),
        style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
