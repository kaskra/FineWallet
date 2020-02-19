import 'package:FineWallet/src/overview_page2/parts/row_item.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/views/savings.dart';
import 'package:FineWallet/src/widgets/views/savings_difference.dart';
import 'package:flutter/material.dart';

class SavingsItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RowItem(
            child: SavingsView(
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4),
            footerText: "Saved amount",
          ),
          RowItem(
            child: SavingsDifferenceView(
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4),
            footerText: "Currently",
          ),
        ],
      ),
    );
  }
}
