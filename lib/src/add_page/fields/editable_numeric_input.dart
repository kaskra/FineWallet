import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/add_page/page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditableNumericInputText extends StatefulWidget {
  final double defaultValue;
  final int currencyId;

  final Function(double) onChanged;

  const EditableNumericInputText({
    Key key,
    this.defaultValue = 0.0,
    @required this.currencyId,
    @required this.onChanged,
  })  : assert(currencyId != null),
        super(key: key);

  @override
  _EditableNumericInputTextState createState() =>
      _EditableNumericInputTextState();
}

class _EditableNumericInputTextState extends State<EditableNumericInputText> {
  TextEditingController _controller;

  bool _loadedSuffixSymbol = false;
  String _suffixSymbol = "";

  @override
  void initState() {
    if (widget.defaultValue != null) {
      _controller = TextEditingController.fromValue(
          TextEditingValue(text: widget.defaultValue.toString()));
    } else {
      _controller = TextEditingController();
    }
    _controller.selection =
        TextSelection(baseOffset: 0, extentOffset: _controller.text.length);

    super.initState();
  }

  Future _loadSuffixSymbol() async {
    final currency = await Provider.of<AppDatabase>(context)
        .currencyDao
        .getCurrencyById(widget.currencyId);
    setState(() {
      _suffixSymbol = currency.symbol;
      _loadedSuffixSymbol = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loadedSuffixSymbol) {
      _loadSuffixSymbol();
    }

    return RowWrapper(
      child: TextFormField(
        controller: _controller,
        textAlign: TextAlign.right,
        textInputAction: TextInputAction.done,
        enableInteractiveSelection: false,
        enableSuggestions: false,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          suffixText: _suffixSymbol,
          labelText: LocaleKeys.add_page_amount.tr(),
          icon: const Icon(Icons.attach_money),
          // errorStyle:
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (String value) {
          _validateAndSend(value);
        },
        validator: (value) {
          if (value == null ||
              double.tryParse(value.replaceAll(",", ".")) == null) {
            return LocaleKeys.add_page_not_a_number.tr();
          }
          if (double.tryParse(value.replaceAll(",", ".")) == 0) {
            return LocaleKeys.add_page_amount_equals_zero.tr();
          }
          if (double.tryParse(value.replaceAll(",", ".")) < 0) {
            return LocaleKeys.add_page_amount_smaller_zero.tr();
          }
          return null;
        },
        // TODO needed?
        onFieldSubmitted: (value) {
          _validateAndSend(value);
        },
        onSaved: (value) {
          _validateAndSend(value);
        },
        autofocus: true,
        autocorrect: false,
      ),
    );
  }

  void _validateAndSend(String text) {
    if (widget.onChanged != null) {
      final res = double.tryParse(text.replaceAll(",", "."));
      if (res != null) {
        widget.onChanged(res);
      }
    }
  }
}
