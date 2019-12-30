import 'package:FineWallet/src/overview_page2/parts/monthly_expense_chart.dart';
import 'package:flutter/material.dart';

class MonthlyExpenseItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MonthlyExpenseChart(
        radius: 40,
        thickness: 6,
      ),
    );
  }
}
