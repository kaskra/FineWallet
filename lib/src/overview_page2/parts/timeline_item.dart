import 'package:FineWallet/src/overview_page/week_overview_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimelineItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: WeekOverviewTimeline(
        context: context,
        fontSize: 14,
      ),
    );
  }
}
