import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _GeneralAmountString extends StatelessWidget {
  final double amount;
  final TextStyle textStyle;
  final String currencySymbol;

  final bool signed;
  final bool colored;
  final bool foreign;

  const _GeneralAmountString(
    this.amount, {
    Key key,
    this.textStyle,
    this.currencySymbol = '€',
    this.signed = false,
    this.colored = false,
    this.foreign = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var value = amount ?? 0;

    // There are 'two' zeros, -0.0 and 0.0, we only want to display 0.0.
    if (value == -0.0) {
      value = 0.0;
    }

    final sign = signed ? (value < 0 ? "" : "+") : "";
    final color = value < 0 ? Colors.red : Colors.green;

    var displayedText = "$sign${value.toStringAsFixed(2)}$currencySymbol";
    if (foreign) {
      displayedText = "($displayedText)";
    }
    return Text(
      displayedText,
      style: colored ? textStyle.copyWith(color: color) : textStyle,
    );
  }
}

class ForeignAmountString extends StatelessWidget {
  final double amount;
  final TextStyle textStyle;
  final String currencySymbol;

  final bool signed;
  final bool colored;

  const ForeignAmountString(
    this.amount, {
    Key key,
    this.textStyle,
    this.currencySymbol = '€',
    this.signed = false,
    this.colored = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _GeneralAmountString(
      amount,
      key: key,
      currencySymbol: currencySymbol,
      textStyle: textStyle,
      signed: signed,
      colored: colored,
    );
  }
}

class AmountString extends StatelessWidget {
  final double amount;
  final TextStyle textStyle;

  final bool signed;
  final bool colored;

  const AmountString(
    this.amount, {
    Key key,
    this.textStyle,
    this.signed = false,
    this.colored = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencySymbol =
        Provider.of<LocalizationNotifier>(context, listen: true).userCurrency;

    return _GeneralAmountString(
      amount,
      key: key,
      colored: colored,
      signed: signed,
      textStyle: textStyle,
      foreign: false,
      currencySymbol: currencySymbol,
    );
  }
}
