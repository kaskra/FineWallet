import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/add_page/page.dart';
import 'package:FineWallet/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DateInput extends StatelessWidget {
  final DateTime date;
  final TextEditingController _dateController;

  final Function(DateTime) onChanged;

  const DateInput({
    Key key,
    @required TextEditingController dateController,
    @required this.onChanged,
    @required this.date,
  })  : assert(onChanged != null),
        assert(date != null),
        _dateController = dateController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RowWrapper(
      child: TextFormField(
        controller: _dateController,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          labelText: LocaleKeys.add_page_date.tr(),
          icon: const Icon(Icons.calendar_today),
        ),
        autovalidateMode: AutovalidateMode.always,
        readOnly: true,
        onTap: () async {
          await _chooseDate(context);
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

  Future _chooseDate(BuildContext context) async {
    final pickedDate = await pickDate(context, date, DateTime(2000));
    if (pickedDate != null) {
      final formatter = DateFormat.yMd(context.locale.toLanguageTag());
      _dateController.text = formatter.format(pickedDate);
      onChanged(pickedDate);
    }
  }
}
