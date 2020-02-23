import 'package:FineWallet/src/widgets/structure/structure_title.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class HistoryDateTitle extends StatelessWidget {
  final DateTime date;

  const HistoryDateTitle({Key key, @required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl.DateFormat d = intl.DateFormat.MMMEd();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: StructureTitle(
        text: d.format(date),
      ),
    );
  }
}
