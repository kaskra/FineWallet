import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/widgets/information_row.dart';
import 'package:FineWallet/src/widgets/views/available_budget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AvailableBudgetItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InformationRow(
      padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, right: 8.0),
      text: Text(
        "${LocaleKeys.profile_page_total_avail_budget.tr()}: ",
        style: const TextStyle(fontSize: 14),
      ),
      value: const AvailableBudgetView(
        textStyle: TextStyle(fontSize: 14),
      ),
    );
  }
}
