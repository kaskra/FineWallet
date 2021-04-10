import 'package:FineWallet/data/providers/providers.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/profile_page/parts/parts.dart';
import 'package:FineWallet/src/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryChartsItem extends StatefulWidget {
  @override
  _CategoryChartsItemState createState() => _CategoryChartsItemState();
}

class _CategoryChartsItemState extends State<CategoryChartsItem> {
  final PageController controller =
      PageController(initialPage: UserSettings.getDefaultProfileChart());

  String _title = "";

  @override
  void initState() {
    setState(() {
      _title = getDefaultTitle();
    });
    super.initState();
    controller.addListener(() {
      setState(() {
        _title = getCurrentTitle();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedCard(
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(5),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _title,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
                Expanded(child: _pages(context)),
              ],
            ),
            PageViewIndicator(
              numberOfChildren: 2,
              controller: controller,
            )
          ],
        ),
      ),
    );
  }

  Widget _pages(BuildContext context) {
    return PageView(
      controller: controller,
      children: const <Widget>[
        CategoryChart(),
        CategoryChart(type: CategoryChart.lifeChart),
      ],
    );
  }

  String getDefaultTitle() {
    if (UserSettings.getDefaultProfileChart() == 1) {
      return LocaleKeys.profile_page_lifetime.tr();
    } else {
      return LocaleKeys.profile_page_monthly.tr();
    }
  }

  String getCurrentTitle() {
    if (controller.page > 0.5) {
      return LocaleKeys.profile_page_lifetime.tr();
    } else {
      return LocaleKeys.profile_page_monthly.tr();
    }
  }
}

class SpendingPredictionItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedCard(
      child: Container(
        height: 200,
        padding: const EdgeInsets.only(right: 12.0, top: 12.0),
        child: PredictionChart(
          monthlyBudget: Provider.of<BudgetNotifier>(context).totalBudget,
        ),
      ),
    );
  }
}
