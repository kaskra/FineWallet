import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/src/widgets/formatted_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavingsDifferenceView extends StatelessWidget {
  final TextStyle textStyle;

  const SavingsDifferenceView({Key key, @required this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<AppDatabase>(context)
          .monthDao
          .watchCurrentMonthWithDetails(),
      builder: (context, AsyncSnapshot<MonthWithDetails> snapshot) {
        final double value = snapshot.hasData ? snapshot.data.savings : 0;
        return AmountString(
          value,
          textStyle: textStyle,
          colored: true,
          signed: true,
        );
      },
    );
  }
}
