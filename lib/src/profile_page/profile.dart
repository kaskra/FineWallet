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
  ProfilePage({this.showAppBar: true});

  final bool showAppBar;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _chartType = ProfileChart.MONTHLY_CHART;
  double _currentMaxMonthlyBudget = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showPrediction = false;

  Widget _categoryBox() {
    return Stack(
      children: <Widget>[
        Column(children: <Widget>[
          Text(
            _showPrediction
                ? "Spending prediction"
                : "${_chartType == ProfileChart.MONTHLY_CHART ? "Monthly" : "Lifetime"} expenses",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            height: 200,
            padding: const EdgeInsets.all(15),
            child: _showPrediction
                ? SpendingPredictionChart(
                    monthlyBudget: _currentMaxMonthlyBudget,
                  )
                : ProfileChart(
                    type: _chartType,
                  ),
          ),
        ]),
        Align(
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
        ),
      ],
    );
  }

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
        ExpandToWidth(
            child: DecoratedCard(child: _categoryBox(), borderRadius: radius)),
        SavingsBox(
          borderRadius: radius,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xffd8e7ff),
      resizeToAvoidBottomInset: true,
      appBar: widget.showAppBar
          ? AppBar(
              iconTheme: Theme.of(context).iconTheme,
              centerTitle: true,
              title: Text(
                "Profile",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            )
          : null,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: _buildBody(),
        ),
      ),
    );
  }
}
