/*
 * Project: FineWallet
 * Last Modified: Sunday, 22nd September 2019 6:39:50 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/constants.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:flutter/material.dart';

class BudgetOverview extends StatelessWidget {
  const BudgetOverview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandToWidth(
      child: DecoratedCard(
        color: Theme.of(context).colorScheme.primary,
        borderWidth: 0,
        borderRadius: BorderRadius.circular(CARD_RADIUS),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "130€", // TODO add bloc
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 26),
            ),
            Text(
              "Available budget",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary, fontSize: 13),
            )
          ],
        ),
      ),
    );
  }
}

class DayOverview2 extends StatelessWidget {
  const DayOverview2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandToWidth(
      child: DecoratedCard(
        borderWidth: 0,
        borderRadius: BorderRadius.circular(10),
        child: const SizedBox(
          height: 50,
        ),
      ),
    );
  }
}
