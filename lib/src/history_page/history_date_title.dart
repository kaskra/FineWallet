import 'package:FineWallet/src/widgets/structure/structure_title.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryDateTitle extends StatelessWidget {
  final DateTime date;

  const HistoryDateTitle({Key key, @required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat d = DateFormat.MMMEd(context.locale.toLanguageTag());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: StructureTitle(
        text: d.format(date),
      ),
    );
  }
}
