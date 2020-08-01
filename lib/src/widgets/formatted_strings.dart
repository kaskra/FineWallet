import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    var value = amount ?? 0;

    // There are 'two' zeros, -0.0 and 0.0, we only want to display 0.0.
    if (value == -0.0) {
      value = 0.0;
    }

    final sign = signed ? (value < 0 ? "" : "+") : "";
    final color = value < 0 ? Colors.red : Colors.green;

    final currencySymbol =
        Provider.of<LocalizationNotifier>(context, listen: true).userCurrency;

    final displayedText = "$sign${value.toStringAsFixed(2)}$currencySymbol";

    return Text(
      displayedText,
      style: colored ? textStyle.copyWith(color: color) : textStyle,
    );
  }
}
