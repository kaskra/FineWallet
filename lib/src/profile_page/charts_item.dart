import 'package:FineWallet/data/providers/budget_notifier.dart';
import 'package:FineWallet/src/profile_page/profile_chart.dart';
import 'package:FineWallet/src/profile_page/spending_prediction_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryChartsItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(5),
      child: _buildPages(context),
    );
  }

  Widget _buildPages(BuildContext context) {
    return PageView(
      controller: PageController(initialPage: 0),
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
            type: ProfileChart.MONTHLY_CHART,
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
