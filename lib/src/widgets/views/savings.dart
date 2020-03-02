import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/src/widgets/formatted_strings.dart';
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
      builder: (context, AsyncSnapshot<double> snapshot) {
        return AmountString(
          snapshot.data,
          textStyle: textStyle,
        );
      },
    );
  }
}
