import 'package:FineWallet/src/overview_page2/parts/budget_overview_item.dart';
import 'package:FineWallet/src/overview_page2/parts/latest_transaction_item.dart';
import 'package:FineWallet/src/overview_page2/parts/monthly_expense_item.dart';
import 'package:FineWallet/src/overview_page2/parts/timeline_item.dart';
import 'package:FineWallet/src/widgets/structure/structure_divider.dart';
import 'package:FineWallet/src/widgets/structure/structure_space.dart';
import 'package:FineWallet/src/widgets/structure/structure_title.dart';
import 'package:flutter/material.dart';

class NewOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StructureTitle(text: "Remaining budget"),
            StructureDivider(),
            StructureSpace(),
            BudgetOverviewItem(),
            StructureSpace(),
            //
            StructureTitle(text: "Latest transaction"),
            StructureDivider(),
            LatestTransactionItem(),
            StructureSpace(),
            StructureSpace(),
            //
            StructureTitle(text: "Used budget"),
            StructureDivider(),
            StructureSpace(),
            MonthlyExpenseItem(),
            //
            StructureTitle(text: "Last week"),
            StructureDivider(),
            TimelineItem(),
            StructureSpace(),
          ],
        ),
      ),
    );
  }
}
