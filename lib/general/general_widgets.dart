/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:16:17 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:flutter/material.dart';

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
