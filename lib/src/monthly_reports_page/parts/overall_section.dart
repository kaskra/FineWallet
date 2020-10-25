import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/monthly_reports_page/parts/used_budget_bar.dart';
import 'package:FineWallet/src/widgets/formatted_strings.dart';
import 'package:FineWallet/src/widgets/row_item.dart';
import 'package:FineWallet/src/widgets/standalone/result_arrow.dart';
import 'package:FineWallet/src/widgets/structure/structure_space.dart';
import 'package:FineWallet/src/widgets/structure/structure_title.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OverallDetail extends StatelessWidget {
  final MonthWithDetails month;

  const OverallDetail({Key key, @required this.month}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final savings = month.income - month.expense;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StructureTitle(
          text: LocaleKeys.reports_page_overall.tr(),
        ),
        SmallStructureSpace(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: UsedBudgetBar(
            model: month,
            padding: const EdgeInsets.only(),
          ),
        ),
        StructureSpace(),
        Row(
          children: <Widget>[
            RowItem(
              amountPadding: const EdgeInsets.symmetric(vertical: 4),
              footerText: LocaleKeys.reports_page_total_income.tr(),
              footerTextColor: Theme.of(context).colorScheme.onBackground,
              child: AmountString(
                month.income,
                signed: true,
                colored: true,
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            const ResultArrow(),
            RowItem(
              amountPadding: const EdgeInsets.symmetric(vertical: 4),
              footerText: LocaleKeys.reports_page_total_expense.tr(),
              footerTextColor: Theme.of(context).colorScheme.onBackground,
              child: AmountString(
                month.expense * -1,
                signed: true,
                colored: true,
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        StructureSpace(),
        Row(
          children: <Widget>[
            RowItem(
              amountPadding: const EdgeInsets.symmetric(vertical: 4),
              footerText: LocaleKeys.savings_name.tr(),
              footerTextColor: Theme.of(context).colorScheme.onBackground,
              child: AmountString(
                savings,
                signed: true,
                colored: true,
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
