import 'package:FineWallet/core/datatypes/update_transaction_modifier.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UpdateModifierDialog extends StatefulWidget {
  @override
  _UpdateModifierDialogState createState() => _UpdateModifierDialogState();
}

class _UpdateModifierDialogState extends State<UpdateModifierDialog> {
  UpdateModifierFlag _selectedModifier = UpdateModifierFlag.all;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadioListTile(
          value: UpdateModifierFlag.all,
          groupValue: _selectedModifier,
          title: Text(LocaleKeys.add_page_all_transactions.tr()),
          onChanged: _select,
        ),
        RadioListTile(
          value: UpdateModifierFlag.onlyFuture,
          title: Text(LocaleKeys.add_page_all_future_transactions.tr()),
          groupValue: _selectedModifier,
          onChanged: _select,
        ),
        // RadioListTile(
        //   value: UpdateModifierFlag.onlySelected,
        //   title: Text(LocaleKeys.add_page_only_selected_transaction.tr()),
        //   groupValue: _selectedModifier,
        //   onChanged: _select,
        // ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context, _selectedModifier);
              },
              child: Text(LocaleKeys.ok.tr().toUpperCase()),
            ),
          ),
        )
      ],
    ));
  }

  void _select(UpdateModifierFlag modifierFlag) {
    setState(() {
      _selectedModifier = modifierFlag;
    });
  }
}
