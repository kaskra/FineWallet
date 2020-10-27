import 'package:FineWallet/constants.dart';
import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/monthly_reports_page/page.dart';
import 'package:FineWallet/src/profile_page/page.dart';
import 'package:FineWallet/src/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DetailsBottomSheet extends StatelessWidget {
  final MonthWithDetails month;

  const DetailsBottomSheet({Key key, @required this.month}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        child: Column(
          children: <Widget>[
            _buildTitle(context),
            StructureDivider(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 8.0),
                  child: Column(
                    children: <Widget>[
                      OverallDetail(month: month),
                      StructureSpace(),
                      _buildCategoryChart(),
                      _buildCategoryList(context),
                      StructureSpace(),
                      StructureSpace(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final formatter = DateFormat.yMMMM(context.locale.toLanguageTag());

    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Positioned(
          top: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
            width: 25,
            height: 3,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            formatter.format(month.month.firstDate),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StructureTitle(
          text: LocaleKeys.profile_page_expenses_per_category.tr(),
        ),
        SizedBox(
          height: 170,
          child: ProfileChart(
            filterSettings: TransactionFilterSettings(
              dateInMonth: month.month.firstDate,
              expenses: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    return CategoryListView(
      model: month,
      context: context,
    );
  }
}
