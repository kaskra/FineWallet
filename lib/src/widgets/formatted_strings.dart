import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForeignAmountString extends StatelessWidget {
  final double amount;
  final TextStyle textStyle;
  final int currencyId;
  final bool signed;
  final bool colored;

  const ForeignAmountString(
    this.amount, {
    Key key,
    this.textStyle,
    this.currencyId,
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

    return FutureBuilder(
      future: Provider.of<AppDatabase>(context, listen: false)
          .currencyDao
          .getCurrencyById(currencyId),
      builder: (context, AsyncSnapshot<Currency> snapshot) {
        if (snapshot.hasData) {
          final displayedText =
              "($sign${value.toStringAsFixed(2)}${snapshot.data.symbol})";
          return Text(
            displayedText,
            style: colored ? textStyle.copyWith(color: color) : textStyle,
          );
        } else {
          return Container();
        }
      },
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
