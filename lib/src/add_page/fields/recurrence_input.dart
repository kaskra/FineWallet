import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'file:///E:/Flutter/FineWallet/lib/src/add_page/parts/recurrence_dialog.dart';
import 'file:///E:/Flutter/FineWallet/lib/src/add_page/parts/row_wrapper.dart';

class RecurrenceTypeInput extends StatelessWidget {
  final DateTime date;
  final RecurrenceType recurrenceType;
  final TextEditingController _recurrenceController;

  final Function(RecurrenceType) onChanged;

  const RecurrenceTypeInput({
    Key key,
    @required TextEditingController recurrenceController,
    @required this.onChanged,
    @required this.recurrenceType,
    @required this.date,
  })  : assert(onChanged != null),
        assert(recurrenceType != null),
        assert(date != null),
        _recurrenceController = recurrenceController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RowWrapper(
      child: TextFormField(
        controller: _recurrenceController,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          labelText: LocaleKeys.add_page_recurrence.tr(),
          icon: const Icon(Icons.replay),
        ),
        autovalidateMode: AutovalidateMode.always,
        readOnly: true,
        onTap: () async {
          await _chooseRecurrence(context);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return LocaleKeys.add_page_date_null.tr();
          }
          return null;
        },
      ),
    );
  }

  Future _chooseRecurrence(BuildContext context) async {
    final RecurrenceType rec = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return RecurrenceDialog(
          recurrenceType: recurrenceType?.id ?? -1,
          date: date,
        );
      },
    );
    if (rec != null) {
      onChanged(rec);
    }
  }
}
