import 'package:FineWallet/data/resources/asset_dictionary.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/row_item.dart';
import 'package:FineWallet/src/widgets/structure/structure_space.dart';
import 'package:FineWallet/src/widgets/views/savings.dart';
import 'package:FineWallet/src/widgets/views/savings_difference.dart';
import 'package:flutter/material.dart';

class SavingsDifferenceItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedCard(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Image.asset(
              Images.SAVINGS,
              height: 100,
              semanticLabel: "Savings",
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RowItem(
                child: SavingsView(
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                amountPadding: const EdgeInsets.symmetric(vertical: 4),
                footerText: "Saved amount",
              ),
              RowItem(
                child: SavingsDifferenceView(
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                amountPadding: const EdgeInsets.symmetric(vertical: 4),
                footerText: "Current Difference", // TODO: or Currently
              ),
            ],
          ),
          StructureSpace()
        ],
      ),
    );
  }
}
