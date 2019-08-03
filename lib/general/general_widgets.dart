/*
 * Developed by Lukas Krauch $file.today.day.$file.today.month.$file.today.year.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:flutter/material.dart';

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

Future<bool> showConfirmDialog(
    BuildContext context, String title, String content) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text("Confirm"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      }).then((v) {
    return v;
  });
}
