import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/profile_page/parts/available_budget_item.dart';
import 'package:FineWallet/src/profile_page/parts/charts_item.dart';
import 'package:FineWallet/src/profile_page/parts/expected_savings_item.dart';
import 'package:FineWallet/src/profile_page/parts/savings_item.dart';
import 'package:FineWallet/src/profile_page/parts/slider_item.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/structure/structure_space.dart';
import 'package:FineWallet/src/widgets/structure/structure_title.dart';
import 'package:easy_localization/easy_localization.dart';
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
            StructureTitle(
                text: LocaleKeys.profile_page_month_avail_budget.tr()),
            SmallStructureSpace(),
            _buildMonthlyAvailableBudget(),
            StructureSpace(),
            //
            StructureTitle(
                text: LocaleKeys.profile_page_spending_prediction.tr()),
            SmallStructureSpace(),
            SpendingPredictionItem(),
            StructureSpace(),
            //
            StructureTitle(
                text: LocaleKeys.profile_page_expenses_per_category.tr()),
            SmallStructureSpace(),
            CategoryChartsItem(),
            //
            StructureTitle(text: LocaleKeys.savings_name.tr()),
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
