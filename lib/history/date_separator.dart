/*
 * Developed by Lukas Krauch 3.8.19.
 * Copyright (c) 2019. All rights reserved.
 *
 */
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class DateSeparator extends StatelessWidget {
  final bool isToday;
  final int dateInMillis;
  DateSeparator({@required this.isToday, @required this.dateInMillis});

  String _getDateString() {
    intl.DateFormat d = intl.DateFormat.MMMEd();
    return d
        .format(DateTime.fromMillisecondsSinceEpoch(dateInMillis))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black38,
            ),
            child: Text(
              isToday ? "TODAY" : _getDateString(),
              style: TextStyle(
                  color: Theme.of(context).textTheme.button.color,
                  fontSize: 11,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.bold),
            )));
  }
}
