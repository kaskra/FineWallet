import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/overview_page/parts/budget_overview_item.dart';
import 'package:FineWallet/src/overview_page/parts/latest_transaction_item.dart';
import 'package:FineWallet/src/overview_page/parts/savings_difference_item.dart';
import 'package:FineWallet/src/overview_page/parts/timeline_item.dart';
import 'package:FineWallet/src/widgets/structure/structure_space.dart';
import 'package:FineWallet/src/widgets/structure/structure_title.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StructureTitle(
              text: LocaleKeys.overview_page_remaining_budget.tr(),
            ),
            SmallStructureSpace(),
            BudgetOverviewItem(),
            StructureSpace(),
            //
            StructureTitle(
              text: LocaleKeys.overview_page_latest_transactions.tr(),
            ),
            SmallStructureSpace(),
            LatestTransactionItem(),
            StructureSpace(),
            //
            StructureTitle(
              text: LocaleKeys.overview_page_savings.tr(),
            ),
            SmallStructureSpace(),
            SavingsDifferenceItem(),
            StructureSpace(),
            //
            StructureTitle(
              text: LocaleKeys.overview_page_last_week.tr(),
            ),
            SmallStructureSpace(),
            TimelineItem(),
            StructureSpace(),
          ],
        ),
      ),
    );
  }
}
