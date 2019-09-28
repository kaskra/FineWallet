import 'package:FineWallet/core/resources/blocs/month_bloc.dart';
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
        child: Column(
          children: <Widget>[
            Text(
              "Savings",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SavingsWidget(
              textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primaryVariant),
            ),
          ],
        ),
        borderRadius: borderRadius,
      ),
    );
  }
}

class SavingsWidget extends StatelessWidget {
  final TextStyle textStyle;
  const SavingsWidget({Key key, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MonthBloc>(
      builder: (context, bloc, child) {
        bloc.getSavings();
        return StreamBuilder(
          initialData: 0.0,
          stream: bloc.savings,
          builder: (context, snapshot) {
            return Text(
              "${(snapshot.hasData ? snapshot.data : 0).toStringAsFixed(2)}€",
              style: textStyle,
            );
          },
        );
      },
    );
  }
}
