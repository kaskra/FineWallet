import 'package:FineWallet/src/overview_page/week_overview_view.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:flutter/material.dart';

class WeekOverview extends StatelessWidget {
  const WeekOverview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandToWidth(
      child: DecoratedCard(
        borderWidth: 0,
        borderRadius: BorderRadius.circular(10),
        child: WeekOverviewView(
          context: context,
        ),
      ),
    );
  }
}
