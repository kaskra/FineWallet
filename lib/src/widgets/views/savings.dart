import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This class is used to display a [Text] widget with the
/// savings up to the current month.
class SavingsView extends StatelessWidget {
  final TextStyle textStyle;

  const SavingsView({Key key, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: 0.0,
      stream:
          Provider.of<AppDatabase>(context).transactionDao.watchTotalSavings(),
      builder: (context, snapshot) {
        return Text(
          "${(snapshot.hasData ? snapshot.data : 0).toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).userCurrency}",
          style: textStyle,
        );
      },
    );
  }
}
