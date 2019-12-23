import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditableNumericInputText extends StatefulWidget {
  final double defaultValue;

  final Function(double) onChanged;
  final Function(bool) onError;

  const EditableNumericInputText({
    Key key,
    this.defaultValue = 0.0,
    @required this.onChanged,
    this.onError,
  }) : super(key: key);

  @override
  _EditableNumericInputTextState createState() =>
      _EditableNumericInputTextState();
}

class _EditableNumericInputTextState extends State<EditableNumericInputText> {
  TextEditingController _controller;

  bool _foundError = false;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _foundError ? Colors.red.withOpacity(0.8) : Colors.transparent,
      ),
      child: TextFormField(
        controller: _controller,
        textAlign: TextAlign.right,
        textInputAction: TextInputAction.done,
        enableInteractiveSelection: false,
        enableSuggestions: false,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          suffixStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 16,
          ),
          suffixText: Provider.of<LocalizationNotifier>(context).currency,
        ),
        onChanged: (String value) {
          var res = double.tryParse(value);
          setState(() {
            _foundError = (res == null);
          });
          if (widget.onError != null) {
            widget.onError(_foundError);
          }
        },
        onFieldSubmitted: (value) {
          _validateAndSend(value);
        },
        onSaved: (value) {
          _validateAndSend(value);
        },
        maxLines: 1,
        autofocus: true,
        autocorrect: false,
      ),
    );
  }

  void _validateAndSend(String text) {
    if (widget.onChanged != null) {
      var res = double.tryParse(text);
      if (res == null) {
        setState(() {
          _foundError = true;
        });
      } else {
        setState(() {
          _foundError = false;
        });
        widget.onChanged(res);
        if (widget.onError != null) {
          widget.onError(_foundError);
        }
      }
    }
  }
}
