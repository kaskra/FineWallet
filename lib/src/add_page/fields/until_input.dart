import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/add_page/page.dart';
import 'package:FineWallet/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UntilInput extends StatefulWidget {
  final DateTime date;
  final DateTime untilDate;
  final bool isLimitedRecurrence;
  final TextEditingController _untilDateController;

  final Function(DateTime) onChanged;
  final Function(bool) onSwitch;

  const UntilInput({
    Key key,
    @required TextEditingController untilController,
    @required this.onChanged,
    @required this.onSwitch,
    @required this.untilDate,
    @required this.date,
    @required this.isLimitedRecurrence,
  })  : assert(onChanged != null),
        assert(onSwitch != null),
        assert(untilDate != null),
        assert(date != null),
        _untilDateController = untilController,
        super(key: key);

  @override
  _UntilInputState createState() => _UntilInputState();
}

class _UntilInputState extends State<UntilInput> {
  bool _isLimitedRecurrence;

  @override
  void initState() {
    super.initState();
    _isLimitedRecurrence = widget.isLimitedRecurrence ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return RowWrapper(
      isChild: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _title(context),
          _neverRadioButton(),
          _dateRadioButton(context),
        ],
      ),
    );
  }

  Align _title(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(LocaleKeys.add_page_until.tr().toUpperCase(),
            style: Theme.of(context).textTheme.caption),
      ),
    );
  }

  RadioListTile<bool> _neverRadioButton() {
    return RadioListTile<bool>(
        contentPadding: const EdgeInsets.only(),
        title: const Text("Nie"),
        selected: !_isLimitedRecurrence,
        value: false,
        groupValue: _isLimitedRecurrence,
        onChanged: (v) {
          setState(() {
            _isLimitedRecurrence = v;
          });
          widget.onSwitch(_isLimitedRecurrence);
        });
  }

  RadioListTile<bool> _dateRadioButton(BuildContext context) {
    return RadioListTile<bool>(
      contentPadding: const EdgeInsets.only(),
      selected: _isLimitedRecurrence,
      value: true,
      groupValue: _isLimitedRecurrence,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Expanded(child: Text("Am")),
          _untilDateInput(context),
        ],
      ),
      onChanged: (v) {
        setState(() {
          _isLimitedRecurrence = v;
        });
        widget.onSwitch(_isLimitedRecurrence);
      },
    );
  }

  Expanded _untilDateInput(BuildContext context) {
    return Expanded(
      flex: 5,
      child: TextFormField(
        controller: widget._untilDateController,
        textAlign: TextAlign.right,
        decoration: const InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        autovalidateMode: AutovalidateMode.always,
        readOnly: true,
        onTap: () async {
          final DateTime firstDate = widget.date.add(const Duration(days: 1));
          final DateTime pickedDate =
              await pickDate(context, widget.untilDate, firstDate);
          if (pickedDate != null) {
            setState(() {
              _isLimitedRecurrence = true;
            });
            final formatter = DateFormat.yMd(context.locale.toLanguageTag());
            widget._untilDateController.text = formatter.format(pickedDate);
            widget.onChanged(pickedDate);
            widget.onSwitch(_isLimitedRecurrence);
          }
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
}
