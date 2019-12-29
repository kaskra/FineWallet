import 'package:FineWallet/src/widgets/information_row.dart';
import 'package:FineWallet/src/widgets/views/savings.dart';
import 'package:flutter/material.dart';

class SavingsItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InformationRow(
      padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, right: 8.0),
      text: Text(
        "Saved amount",
        style: TextStyle(fontSize: 14),
      ),
      value: SavingsView(
        textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}
