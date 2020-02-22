import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/row_item.dart';
import 'package:FineWallet/src/widgets/views/savings.dart';
import 'package:flutter/material.dart';

class SimpleSavingsItem extends StatelessWidget {
  final double fontSize;
  final FontWeight fontWeight;

  const SimpleSavingsItem(
      {Key key, this.fontSize = 16, this.fontWeight = FontWeight.bold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedCard(
      child: Row(
        children: <Widget>[
          RowItem(
            child: SavingsView(
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            amountPadding: const EdgeInsets.symmetric(vertical: 4),
            footerText: "Saved amount",
          )
        ],
      ),
    );
  }
}
