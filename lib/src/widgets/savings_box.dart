import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Show the savings of previous months centered in a screen wide box.
class SavingsBox extends StatelessWidget {
  const SavingsBox(
      {Key key,
      BorderRadius borderRadius = BorderRadius.zero,
      double widthRatio = 1})
      : this.borderRadius = borderRadius,
        this.screenWidthRatio = widthRatio,
        super(key: key);

  final BorderRadius borderRadius;
  final double screenWidthRatio;

  @override
  Widget build(BuildContext context) {
    return ExpandToWidth(
      ratio: screenWidthRatio,
      child: DecoratedCard(
        borderColor: Theme.of(context).colorScheme.primary,
        borderWidth: 0,
        borderRadius: borderRadius,
        child: Column(
          children: <Widget>[
            Text(
              "Savings",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSecondary),
            ),
            SavingsWidget(
              textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
          ],
        ),
      ),
    );
  }
}

/// This class is used to display a [Text] widget with the
/// savings up to the current month.
class SavingsWidget extends StatelessWidget {
  final TextStyle textStyle;

  const SavingsWidget({Key key, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: 0.0,
      stream:
          Provider.of<AppDatabase>(context).transactionDao.watchTotalSavings(),
      builder: (context, snapshot) {
        return Text(
          "${(snapshot.hasData ? snapshot.data : 0).toStringAsFixed(2)}€",
          style: textStyle,
        );
      },
    );
  }
}
