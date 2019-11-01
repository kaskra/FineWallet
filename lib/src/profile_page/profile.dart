/*
 * Project: FineWallet
 * Last Modified: Saturday, 14th September 2019 5:36:48 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/constants.dart';
import 'package:FineWallet/src/profile_page/profile_chart.dart';
import 'package:FineWallet/src/profile_page/slider_box.dart';
import 'package:FineWallet/src/profile_page/spending_prediction_chart.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/savings_box.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage();
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double _currentMaxMonthlyBudget = 0;

  Widget _buildBody() {
    BorderRadius radius = BorderRadius.circular(CARD_RADIUS);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        BudgetSlider(
          onChanged: (value) => {
            setState(() {
              _currentMaxMonthlyBudget = value;
            }),
          },
          borderRadius: radius,
        ),
        ProfileCharts(
          radius: radius,
          maxCurrentBudget: _currentMaxMonthlyBudget,
        ),
        SavingsBox(
          borderRadius: radius,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: _buildBody(),
      ),
    );
  }
}

class ProfileCharts extends StatefulWidget {
  const ProfileCharts({
    Key key,
    @required this.radius,
    @required this.maxCurrentBudget,
  }) : super(key: key);

  final BorderRadius radius;
  final double maxCurrentBudget;

  @override
  _ProfileChartsState createState() => _ProfileChartsState();
}

class _ProfileChartsState extends State<ProfileCharts> {
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
                      monthlyBudget: widget.maxCurrentBudget,
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
                        color: Theme.of(context).colorScheme.onBackground,
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
                  color: Theme.of(context).colorScheme.onBackground,
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
  Widget build(BuildContext context) {
    return ExpandToWidth(
      child: DecoratedCard(
        child: _buildCategoryBox(),
        borderRadius: widget.radius,
        borderColor: Theme.of(context).colorScheme.primary,
        borderWidth: 0,
      ),
    );
  }
}
