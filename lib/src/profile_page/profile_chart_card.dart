/*
 * Project: FineWallet
 * Last Modified: Friday, 1st November 2019 6:09:32 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/profile_page/profile_chart.dart';
import 'package:FineWallet/src/profile_page/spending_prediction_chart.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/providers/budget_notifier.dart';

class ProfileChartCard extends StatefulWidget {
  const ProfileChartCard({Key key}) : super(key: key);

  @override
  _ProfileChartCardState createState() => _ProfileChartCardState();
}

class _ProfileChartCardState extends State<ProfileChartCard> {
  int _chartType = ProfileChart.MONTHLY_CHART;
  bool _showPrediction = false;

  Widget _buildCategoryBox() {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            _buildChartTitleText(),
            Container(
              height: 200,
              padding: const EdgeInsets.all(15),
              child: _showPrediction
                  ? SpendingPredictionChart(
                      monthlyBudget:
                          Provider.of<BudgetNotifier>(context).budget,
                    )
                  : ProfileChart(
                      type: _chartType,
                    ),
            ),
          ],
        ),
        _buildChartControls(),
      ],
    );
  }

  Text _buildChartTitleText() {
    return Text(
      _showPrediction
          ? "Spending prediction"
          : "${_chartType == ProfileChart.MONTHLY_CHART ? "Monthly" : "Lifetime"} expenses",
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Align _buildChartControls() {
    return Align(
      alignment: Alignment.topRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          !_showPrediction
              ? InkWell(
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        Icons.repeat,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSecondary,
                      )),
                  onTap: () {
                    setState(() {
                      _chartType = _chartType == ProfileChart.MONTHLY_CHART
                          ? ProfileChart.LIFE_CHART
                          : ProfileChart.MONTHLY_CHART;
                    });
                  },
                )
              : Container(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.repeat,
                    size: 16,
                    color: Colors.transparent,
                  )),
          InkWell(
              child: Container(
                margin: const EdgeInsets.all(5),
                child: Icon(
                  Icons.show_chart,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              onTap: () {
                setState(() {
                  _showPrediction = !_showPrediction;
                });
              }),
        ],
      ),
    );
  }

  @override
  void initState() {
    setState(() {
      _showPrediction = UserSettings.getDefaultProfileChart() == 2;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandToWidth(
      child: DecoratedCard(
        child: _buildCategoryBox(),
      ),
    );
  }
}
