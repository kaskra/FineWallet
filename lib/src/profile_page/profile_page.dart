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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const StructureTitle(text: "Monthly Available Budget"),
            SmallStructureSpace(),
            _buildMonthlyAvailableBudget(),
            StructureSpace(),
            //
            const StructureTitle(text: "Spending Prediction"),
            SmallStructureSpace(),
            SpendingPredictionItem(),
            StructureSpace(),
            //
            const StructureTitle(text: "Expenses per Category"),
            SmallStructureSpace(),
            CategoryChartsItem(),
            //
            const StructureTitle(text: "Savings"),
            SmallStructureSpace(),
            const SimpleSavingsItem(),
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
