import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:FineWallet/src/widgets/views/savings.dart';
import 'package:flutter/material.dart';

/// Show the savings of previous months centered in a screen wide box.
class SavingsBox extends StatelessWidget {
  const SavingsBox({Key key, double widthRatio = 1})
      : this.screenWidthRatio = widthRatio,
        super(key: key);

  final double screenWidthRatio;

  @override
  Widget build(BuildContext context) {
    return ExpandToWidth(
      ratio: screenWidthRatio,
      child: DecoratedCard(
        child: Column(
          children: <Widget>[
            Text(
              "Savings",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SavingsView(
              textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }
}
