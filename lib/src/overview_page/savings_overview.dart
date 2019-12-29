/*
 * Project: FineWallet
 * Last Modified: Saturday, 28th September 2019 10:26:13 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/views/savings.dart';
import 'package:flutter/material.dart';

class SavingsOverview extends StatelessWidget {
  const SavingsOverview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(right: 5.0),
      child: DecoratedCard(
        child: Stack(
          children: <Widget>[
            Center(
              child: FittedBox(
                child: SavingsView(
                  textStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Savings",
                style: TextStyle(fontSize: 13),
              ),
            )
          ],
        ),
      ),
    );
  }
}
