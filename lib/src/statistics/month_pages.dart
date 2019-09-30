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
import 'package:FineWallet/src/statistics/month_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MonthBloc>(
      builder: (context, bloc, child) {
        bloc.syncMonths();
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
