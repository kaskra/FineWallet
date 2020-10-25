import 'package:FineWallet/constants.dart';
import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/monthly_reports_page/parts/details_bottom_sheet.dart';
import 'package:FineWallet/src/monthly_reports_page/parts/used_budget_bar.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/formatted_strings.dart';
import 'package:FineWallet/src/widgets/structure/structure_space.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CompactDetailsCard extends StatelessWidget {
  final MonthWithDetails month;

  const CompactDetailsCard({Key key, @required this.month}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat.yMMMM(context.locale.toLanguageTag());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: <Widget>[
          DecoratedCard(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: Center(
                    child: Text(
                      formatter.format(month.month.firstDate),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ),
                UsedBudgetBar(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  model: month,
                ),
                _buildDetails(context)
              ],
            ),
          ),
          StructureSpace(),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    final value = month.income - month.expense;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 14),
          child: Column(
            children: <Widget>[
              AmountString(
                value,
                signed: true,
                colored: true,
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                LocaleKeys.savings_saved_amount.tr(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
        _buildDetailsButton(context)
      ],
    );
  }

  Widget _buildDetailsButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14.0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius)),
        onPressed: () {
          _openDetails(context);
        },
        elevation: 4,
        height: 30,
        color: Theme.of(context).colorScheme.secondary,
        child: Row(
          children: <Widget>[
            Text(
              LocaleKeys.reports_page_more_details.tr(),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            Icon(
              Icons.expand_more,
              size: 18,
              color: Theme.of(context).colorScheme.onSurface,
            )
          ],
        ),
      ),
    );
  }

  Future _openDetails(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return DetailsBottomSheet(
          month: month,
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
    );
  }
}
