import 'package:FineWallet/src/profile_page/available_budget_item.dart';
import 'package:FineWallet/src/profile_page/charts_item.dart';
import 'package:FineWallet/src/profile_page/expected_savings_item.dart';
import 'package:FineWallet/src/profile_page/savings_item.dart';
import 'package:FineWallet/src/profile_page/slider_item.dart';
import 'package:FineWallet/src/widgets/structure/structure_divider.dart';
import 'package:FineWallet/src/widgets/structure/structure_space.dart';
import 'package:FineWallet/src/widgets/structure/structure_title.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
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
            StructureDivider(),
            SliderItem(),
            AvailableBudgetItem(),
            ExpectedSavingsItem(),
            StructureSpace(),
            //
            StructureTitle(text: "Spending Prediction"),
            StructureDivider(),
            SpendingPredictionItem(),
            StructureSpace(),
            //
            StructureTitle(text: "Expenses per Category"),
            StructureDivider(),
            CategoryChartsItem(),
            //
            StructureTitle(text: "Savings"),
            StructureDivider(),
            SavingsItem(),
            StructureSpace(),
          ],
        ),
      ),
    );
  }
}
