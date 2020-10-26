import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/overview_page/page.dart';
import 'package:FineWallet/src/widgets/widgets.dart';
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
              text: LocaleKeys.savings_name.tr(),
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
