import 'package:FineWallet/src/overview_page/parts/budget_overview_item.dart';
import 'package:FineWallet/src/overview_page/parts/latest_transaction_item.dart';
import 'package:FineWallet/src/overview_page/parts/savings_difference_item.dart';
import 'package:FineWallet/src/overview_page/parts/timeline_item.dart';
import 'package:FineWallet/src/widgets/structure/structure_space.dart';
import 'package:FineWallet/src/widgets/structure/structure_title.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const StructureTitle(text: "Remaining Budget"),
            SmallStructureSpace(),
            BudgetOverviewItem(),
            StructureSpace(),
            //
            const StructureTitle(text: "Latest Transactions"),
            SmallStructureSpace(),
            LatestTransactionItem(),
            StructureSpace(),
            //
            const StructureTitle(text: "Savings"),
            SmallStructureSpace(),
            SavingsDifferenceItem(),
            StructureSpace(),
            //
            const StructureTitle(text: "Last Week"),
            SmallStructureSpace(),
            TimelineItem(),
            StructureSpace(),
          ],
        ),
      ),
    );
  }
}
