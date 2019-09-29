/*
 * Project: FineWallet
 * Last Modified: Sunday, 29th September 2019 12:27:42 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/resources/transaction_list.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: 0);
    return PageView.builder(
      pageSnapping: true,
      onPageChanged: (pageIndex) {
        print(pageIndex);
      },
      scrollDirection: Axis.horizontal,
      controller: _pageController,
      itemBuilder: (context, index) {
        return MonthCard(
          context,
          date: DateTime.now().add(Duration(days: 30 * index)),
          transactions: TransactionList(),
        );
      },
    );
  }
}

class MonthCard extends StatelessWidget {
  final TransactionList transactions;
  final DateTime date;
  final BuildContext context;

  const MonthCard(this.context,
      {Key key, @required this.transactions, @required this.date})
      : super(key: key);

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

  _buildContent() {
    return Container(
      child: _buildTitle(),
    );
  }

  Center _buildTitle() {
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
}
