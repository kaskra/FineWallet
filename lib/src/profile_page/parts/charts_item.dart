import 'package:FineWallet/data/providers/budget_notifier.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/profile_page/parts/profile_chart.dart';
import 'package:FineWallet/src/profile_page/parts/spending_prediction_chart.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/standalone/page_view_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryChartsItem extends StatelessWidget {
  final PageController controller =
      PageController(initialPage: UserSettings.getDefaultProfileChart());

  @override
  Widget build(BuildContext context) {
    return DecoratedCard(
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(5),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            _buildPages(context),
            PageViewIndicator(
              numberOfChildren: 2,
              controller: controller,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPages(BuildContext context) {
    return PageView(
      controller: controller,
      children: <Widget>[
        _buildChartWrapper(
          context,
          LocaleKeys.profile_page_monthly.tr(),
          const ProfileChart(),
        ),
        _buildChartWrapper(
          context,
          LocaleKeys.profile_page_lifetime.tr(),
          const ProfileChart(
            type: ProfileChart.lifeChart,
          ),
        ),
      ],
    );
  }

  Widget _buildChartWrapper(BuildContext context, String title, Widget chart) {
    return Stack(
      alignment: const Alignment(-0.75, -1),
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.secondary),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: chart,
        ),
      ],
    );
  }
}

class SpendingPredictionItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedCard(
      child: Container(
        height: 200,
        padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
        child: SpendingPredictionChart(
          monthlyBudget: Provider.of<BudgetNotifier>(context).totalBudget,
        ),
      ),
    );
  }
}
