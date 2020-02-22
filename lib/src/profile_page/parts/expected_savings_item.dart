import 'package:FineWallet/src/widgets/information_row.dart';
import 'package:FineWallet/src/widgets/views/expected_savings.dart';
import 'package:flutter/material.dart';

class ExpectedSavingsItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InformationRow(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 5.0, left: 8.0, right: 8.0),
      text: Text(
        "Expected savings: ",
        style: TextStyle(fontSize: 14),
      ),
      value: ExpectedSavingsView(
        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
