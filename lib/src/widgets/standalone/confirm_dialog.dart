/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:16:17 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'dart:async';

import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(
    BuildContext context, String title, String content) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0.0,
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              style:
                  TextButton.styleFrom(primary: Theme.of(context).accentColor),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(LocaleKeys.cancel.tr()),
            ),
            TextButton(
              style:
                  TextButton.styleFrom(primary: Theme.of(context).accentColor),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(LocaleKeys.confirm.tr()),
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
