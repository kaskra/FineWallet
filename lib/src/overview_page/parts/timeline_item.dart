import 'package:FineWallet/src/overview_page/parts/week_overview_timeline.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimelineItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedCard(
      padding: 8,
      child: WeekOverviewTimeline(
        context: context,
        fontSize: 14,
      ),
    );
  }
}
