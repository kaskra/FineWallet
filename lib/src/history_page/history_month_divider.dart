import 'package:FineWallet/src/widgets/structure/structure_divider.dart';
import 'package:flutter/material.dart';

class HistoryMonthDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: StructureDivider(),
    );
  }
}
