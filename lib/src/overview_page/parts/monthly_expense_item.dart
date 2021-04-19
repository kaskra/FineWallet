import 'package:FineWallet/src/overview_page/parts/monthly_expense_chart.dart';
import 'package:flutter/material.dart';

class MonthlyExpenseItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: MonthlyExpenseChart(
        radius: 60,
        thickness: 10,
      ),
    );
  }
}
