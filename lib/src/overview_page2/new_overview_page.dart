import 'package:FineWallet/src/overview_page2/parts/budget_overview_item.dart';
import 'package:FineWallet/src/overview_page2/parts/latest_transaction_item.dart';
import 'package:FineWallet/src/profile_page/savings_item.dart';
import 'package:FineWallet/src/widgets/structure/structure_divider.dart';
import 'package:FineWallet/src/widgets/structure/structure_space.dart';
import 'package:FineWallet/src/widgets/structure/structure_title.dart';
import 'package:flutter/material.dart';

class NewOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: ListView(
          children: <Widget>[
            StructureTitle(
              text: "Budget Overview",
            ),
            StructureDivider(),
            BudgetOverviewItem(),
            StructureSpace(),
            StructureTitle(text: "Latest transaction"),
            StructureDivider(),
            LatestTransactionItem(),
            StructureSpace(),
            StructureTitle(text: "Savings"),
            StructureDivider(),
            SavingsItem()
          ],
        ),
      ),
    );
  }
}
