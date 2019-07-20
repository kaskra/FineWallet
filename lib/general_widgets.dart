/*
 * Developed by Lukas Krauch 21.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

Widget generalCard(
  Widget child, {
  BorderRadius cardBorderRadius = BorderRadius.zero,
  BoxDecoration decoration,
  double padding = 10,
}) {
  return Container(
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: cardBorderRadius),
          child: Container(
              decoration: decoration ?? BoxDecoration(),
              padding: EdgeInsets.all(padding),
              child: child)));
}

Widget growAnimation(
    Widget first, Widget second, bool isExpanded, Duration duration) {
  return AnimatedCrossFade(
    firstChild: first,
    secondChild: second,
    duration: duration,
    crossFadeState:
        isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
  );
}

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
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
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
