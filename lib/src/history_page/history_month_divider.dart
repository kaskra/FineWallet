import 'package:flutter/material.dart';

class HistoryMonthDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Divider(
        endIndent: 10,
        indent: 10,
      ),
    );
  }
}
