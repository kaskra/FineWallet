/*
 * Project: FineWallet
 * Last Modified: Saturday, 14th September 2019 5:36:48 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/constants.dart';
import 'package:FineWallet/src/profile_page/profile_chart_card.dart';
import 'package:FineWallet/src/profile_page/slider_box.dart';
import 'package:FineWallet/src/widgets/savings_box.dart';
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
        ProfileChartCard(
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
