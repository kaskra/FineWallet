import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/resources/asset_dictionary.dart';
import 'package:FineWallet/data/resources/generated/locale_keys.g.dart';
import 'package:FineWallet/src/monthly_reports_page/page.dart';
import 'package:FineWallet/src/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyReportsPage extends StatelessWidget {
  const MonthlyReportsPage({Key key}) : super(key: key);

  Widget _buildPlaceholder(BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Center(
          child: Text(LocaleKeys.reports_page_found_none.tr()),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MonthWithDetails>>(
      stream: Provider.of<AppDatabase>(context)
          .monthDao
          .watchAllMonthsWithDetails(),
      builder: (BuildContext context,
          AsyncSnapshot<List<MonthWithDetails>> snapshot) {
        if (snapshot.hasData) {
          final previousMonths = snapshot.data.where(
              (element) => element.month.lastDate.isBefore(DateTime.now()));

          return ListView(
            children: <Widget>[
              ListHeaderImage(
                semanticLabel: LocaleKeys.reports_page_name.tr(),
                subtitle: LocaleKeys.reports_page_name.tr(),
                image: IMAGES.monthlyReport,
              ),
              // Only display previous months not the current one.
              if (previousMonths.isNotEmpty)
                for (var m in previousMonths) CompactDetailsCard(month: m)
              else
                _buildPlaceholder(context),
            ],
          );
        } else {
          return _buildPlaceholder(context);
        }
      },
    );
  }
}
