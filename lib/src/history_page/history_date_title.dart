import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class HistoryDateTitle extends StatelessWidget {
  final DateTime date;

  const HistoryDateTitle({Key key, @required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    intl.DateFormat d = intl.DateFormat.MMMEd();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 5.0, left: 8.0),
      child: Text(
        d.format(date).toUpperCase(),
        style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}
