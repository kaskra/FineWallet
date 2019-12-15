/*
 * Project: FineWallet
 * Last Modified: Saturday, 28th September 2019 11:47:17 pm
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/src/overview_page/week_overview_timeline.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:flutter/material.dart';

class WeekOverview extends StatelessWidget {
  const WeekOverview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandToWidth(
      child: DecoratedCard(
        child: WeekOverviewTimeline(
          context: context,
        ),
      ),
    );
  }
}
