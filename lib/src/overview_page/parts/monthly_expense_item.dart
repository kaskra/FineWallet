import 'package:FineWallet/src/overview_page/parts/monthly_expense_chart.dart';
import 'package:flutter/material.dart';

class MonthlyExpenseItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: PhysicalModel(
        elevation: 4,
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        child: MonthlyExpenseChart(
          backgroundColor: Theme.of(context).cardColor,
          radius: 60,
          thickness: 10,
        ),
      ),
    );
  }
}
