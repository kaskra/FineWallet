import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/budget_notifier.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/profile_page/page.dart';
import 'package:FineWallet/src/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            StructureTitle(text: LocaleKeys.savings_history.tr()),
            SmallStructureSpace(),
            const SavingsChartItem(),
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
          SliderItem(
            flag: BudgetFlag.monthly,
            streamBuilder: (context) => Provider.of<AppDatabase>(context)
                .transactionDao
                .watchMonthlyIncome(today()),
            title: LocaleKeys.profile_page_monthly_budget.tr(),
          ),
          SliderItem(
            flag: BudgetFlag.savings,
            streamBuilder: (context) => Provider.of<AppDatabase>(context)
                .transactionDao
                .watchTotalSavings(),
            title: LocaleKeys.savings_name.tr(),
          ),
          AvailableBudgetItem(),
          ExpectedSavingsItem(),
        ],
      ),
    );
  }
}
