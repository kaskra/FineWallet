import 'package:FineWallet/src/profile_page/parts/available_budget_item.dart';
import 'package:FineWallet/src/profile_page/parts/charts_item.dart';
import 'package:FineWallet/src/profile_page/parts/expected_savings_item.dart';
import 'package:FineWallet/src/profile_page/parts/savings_item.dart';
import 'package:FineWallet/src/profile_page/parts/slider_item.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/structure/structure_space.dart';
import 'package:FineWallet/src/widgets/structure/structure_title.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StructureTitle(text: "Monthly available budget"),
            SmallStructureSpace(),
            _buildMonthlyAvailableBudget(),
            StructureSpace(),
            //
            StructureTitle(text: "Spending Prediction"),
            SmallStructureSpace(),
            SpendingPredictionItem(),
            StructureSpace(),
            //
            StructureTitle(text: "Expenses per Category"),
            SmallStructureSpace(),
            CategoryChartsItem(),
            //
            StructureTitle(text: "Savings"),
            SmallStructureSpace(),
            SimpleSavingsItem(),
            StructureSpace(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyAvailableBudget() {
    return DecoratedCard(
      child: Column(
        children: <Widget>[
          SliderItem(),
          AvailableBudgetItem(),
          ExpectedSavingsItem(),
        ],
      ),
    );
  }
}
