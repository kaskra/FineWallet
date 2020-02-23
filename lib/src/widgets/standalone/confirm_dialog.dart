/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:16:17 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'dart:async';

import 'package:flutter/material.dart';

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
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Close"),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Confirm"),
            )
          ],
        );
      }).then((v) {
    // weird linting behaviour!
    if (v == null) {
      return false;
    } else {
      return v == true;
    }
  });
}
