import 'package:FineWallet/data/resources/asset_dictionary.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/row_item.dart';
import 'package:FineWallet/src/widgets/structure/structure_space.dart';
import 'package:FineWallet/src/widgets/views/savings.dart';
import 'package:FineWallet/src/widgets/views/savings_difference.dart';
import 'package:easy_localization/easy_localization.dart';
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
              IMAGES.savings,
              height: 100,
              semanticLabel: LocaleKeys.savings_name.tr(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RowItem(
                amountPadding: const EdgeInsets.symmetric(vertical: 4),
                footerText: LocaleKeys.savings_saved_amount.tr(),
                child: const SavingsView(
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              RowItem(
                amountPadding: const EdgeInsets.symmetric(vertical: 4),
                footerText: LocaleKeys.savings_difference.tr(),
                child: const SavingsDifferenceView(
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          StructureSpace()
        ],
      ),
    );
  }
}
