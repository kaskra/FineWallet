import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:flutter/material.dart';

class PlaceholderOverview extends StatelessWidget {
  const PlaceholderOverview({Key key}) : super(key: key);

 @override
Widget build(BuildContext context) {
  return ExpandToWidth(
    horizontalMargin: 0,
    ratio: 0.5,
    height: 50,
    child: DecoratedCard(
      padding: 10,
      borderWidth: 0,
      borderRadius: BorderRadius.circular(10),
      child: Container(),
    ),
  );
}
}
