import 'package:FineWallet/src/widgets/information_row.dart';
import 'package:FineWallet/src/widgets/views/savings.dart';
import 'package:flutter/material.dart';

class SavingsItem extends StatelessWidget {
  final double fontSize;
  final FontWeight fontWeight;

  const SavingsItem(
      {Key key, this.fontSize = 16, this.fontWeight = FontWeight.bold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InformationRow(
      padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, right: 8.0),
      text: Text(
        "Saved amount",
        style: TextStyle(fontSize: fontSize - 2),
      ),
      value: SavingsView(
        textStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}
