import 'package:FineWallet/data/providers/budget_notifier.dart';
import 'package:FineWallet/data/user_settings.dart';
import 'package:FineWallet/src/profile_page/page_view_indicator.dart';
import 'package:FineWallet/src/profile_page/profile_chart.dart';
import 'package:FineWallet/src/profile_page/spending_prediction_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryChartsItem extends StatefulWidget {
  @override
  _CategoryChartsItemState createState() => _CategoryChartsItemState();
}

class _CategoryChartsItemState extends State<CategoryChartsItem> {
  int _selectedPage;

  PageController controller =
      PageController(initialPage: UserSettings.getDefaultProfileChart());

  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        _selectedPage = controller.page.round();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(5),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _buildPages(context),
          PageViewIndicator(
            selectedPage: _selectedPage,
            numberOfChildren: 2,
            initialPage: controller.initialPage,
          )
        ],
      ),
    );
  }

  Widget _buildPages(BuildContext context) {
    return PageView(
      controller: controller,
      children: <Widget>[
        _buildChartWrapper(
          context,
          "Monthly",
          ProfileChart(
            type: ProfileChart.MONTHLY_CHART,
          ),
        ),
        _buildChartWrapper(
          context,
          "Lifetime",
          ProfileChart(
            type: ProfileChart.LIFE_CHART,
          ),
        ),
      ],
    );
  }

  Widget _buildChartWrapper(BuildContext context, String title, Widget chart) {
    return Stack(
      alignment: Alignment(-0.75, -1),
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
    return Container(
      height: 200,
      padding: const EdgeInsets.all(15),
      child: SpendingPredictionChart(
        monthlyBudget: Provider.of<BudgetNotifier>(context).budget,
      ),
    );
  }
}
