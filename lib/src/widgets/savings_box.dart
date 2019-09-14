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
      context: context,
      child: DecoratedCard(
        child: Column(
          children: <Widget>[
            Text(
              "Savings",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Consumer<MonthBloc>(
              builder: (_, bloc, __) {
                bloc.getSavings();
                return StreamBuilder<double>(
                  initialData: 0,
                  stream: bloc.savings,
                  builder: (context, snapshot) {
                    return Text(
                        "${(snapshot.hasData ? snapshot.data : 0).toStringAsFixed(2)}€",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.primaryVariant));
                  },
                );
              },
            )
          ],
        ),
        borderRadius: borderRadius,
      ),
    );
  }
}
