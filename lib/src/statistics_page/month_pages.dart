/*
 * Project: FineWallet
 * Last Modified: Sunday, 29th September 2019 12:27:42 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/src/statistics_page/month_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MonthWithDetails>>(
      stream: Provider.of<AppDatabase>(context)
          .monthDao
          .watchAllMonthsWithDetails(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? PageView(
                controller: _controller,
                pageSnapping: true,
                scrollDirection: Axis.horizontal,
                reverse: true,
                children: <Widget>[
                  for (var m in snapshot.data)
                    MonthCard(
                      key: ObjectKey(m),
                      context: context,
                      model: m,
                    )
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
