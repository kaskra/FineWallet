import 'package:FineWallet/core/resources/blocs/month_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavingsBox extends StatelessWidget {
  const SavingsBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        color: Theme.of(context).colorScheme.primaryVariant));
              },
            );
          },
        )
      ],
    );
  }
}
