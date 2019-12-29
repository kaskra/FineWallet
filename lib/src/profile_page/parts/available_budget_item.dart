import 'package:FineWallet/src/widgets/information_row.dart';
import 'package:FineWallet/src/widgets/views/available_budget.dart';
import 'package:flutter/material.dart';

class AvailableBudgetItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InformationRow(
      padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, right: 8.0),
      text: Text(
        "Total available budget: ",
        style: TextStyle(fontSize: 14),
      ),
      value: AvailableBudgetView(
        textStyle: TextStyle(fontSize: 14),
      ),
    );
  }
}
