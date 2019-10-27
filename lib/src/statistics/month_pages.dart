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
import 'package:flutter/gestures.dart';
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
    return Consumer<MonthBloc>(
      builder: (context, bloc, child) {
        bloc.syncMonths();
        return StreamBuilder<List<MonthModel>>(
          stream: bloc.allMonths,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return GestureDetector(
              // onTapUp: (details) {
              //   if (details.localPosition.dx < context.size.width / 2) {
              //     _controller.nextPage(
              //       curve: Curves.linear,
              //       duration: Duration(milliseconds: 80),
              //     );
              //   } else if (details.localPosition.dx > context.size.width / 2) {
              //     _controller.previousPage(
              //       curve: Curves.linear,
              //       duration: Duration(milliseconds: 80),
              //     );
              //   }
              // },
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity > 0) {
                  _controller.nextPage(
                    curve: Curves.linear,
                    duration: Duration(milliseconds: 80),
                  );
                } else if (details.primaryVelocity < 0) {
                  _controller.previousPage(
                    curve: Curves.linear,
                    duration: Duration(milliseconds: 80),
                  );
                }
              },
              child: snapshot.hasData
                  // FIXME  page view bugs -- loading page next to it into own page (but only listview)
                  // workaround by animation fast between pages
                  ? PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _controller,
                      pageSnapping: true,
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      children: <Widget>[
                        for (MonthModel m in snapshot.data)
                          MonthCard(
                            key: ObjectKey(m),
                            context: context,
                            model: m,
                          )
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            );
          },
        );
      },
    );
  }
}
