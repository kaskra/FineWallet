import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CreateDialog extends StatelessWidget {
  final String title;
  final int maxLength;

  CreateDialog({
    Key key,
    this.title = "",
    this.maxLength = 20,
  }) : super(key: key);

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle(context),
            const SizedBox(
              height: 16,
            ),
            buildTextField(),
            const SizedBox(
              height: 16,
            ),
            //Button
            buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  Align buildConfirmButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: () {
          if (_textEditingController.text.trim().isNotEmpty) {
            Navigator.of(context).pop(_textEditingController.text.trim());
          }
        },
        child: Text(
          LocaleKeys.ok.tr().toUpperCase(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  TextField buildTextField() {
    return TextField(
      controller: _textEditingController,
      maxLength: maxLength,
      keyboardType: TextInputType.text,
      autofocus: true,
      decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      )),
    );
  }

  Text buildTitle(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.subtitle1);
  }
}
