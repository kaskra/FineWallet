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
        height: 250,
        padding: const EdgeInsets.all(5),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                _title,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            PageView(
              controller: controller,
              children: const <Widget>[
                CategoryChart(),
                CategoryChart(type: CategoryChart.lifeChart),
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

class SavingsChartItem extends StatelessWidget {
  final double fontSize;
  final FontWeight fontWeight;

  const SavingsChartItem(
      {Key key, this.fontSize = 16, this.fontWeight = FontWeight.bold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DecoratedCard(
      child: SizedBox(
        height: 200,
        child: Padding(
          padding: EdgeInsets.only(left: 8.0, right: 16, top: 12, bottom: 8),
          child: SavingsChart(),
        ),
      ),
    );
  }
}
