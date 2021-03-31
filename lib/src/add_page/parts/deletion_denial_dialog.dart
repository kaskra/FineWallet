import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DeletionDenialDialog extends StatelessWidget {
  final String denialTitle;
  final String denialText;

  const DeletionDenialDialog({
    Key key,
    this.denialTitle,
    this.denialText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0.0,
      title: Text(denialTitle),
      content: SingleChildScrollView(
        child: Text(denialText),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(primary: Theme.of(context).accentColor),
          child: Text(LocaleKeys.ok.tr().toUpperCase()),
        ),
      ],
    );
  }
}
