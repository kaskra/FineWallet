import 'package:FineWallet/overview_page/day_overview.dart';
import 'package:FineWallet/overview_page/week_overview.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[DayOverview(context), WeekOverview(context)],
        ),
      ),
    );
  }
}
