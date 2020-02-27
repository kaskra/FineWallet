import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/resources/asset_dictionary.dart';
import 'package:FineWallet/src/monthly_reports_page/parts/compact_details.dart';
import 'package:FineWallet/src/widgets/standalone/list_header_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyReportsPage extends StatelessWidget {
  const MonthlyReportsPage({Key key}) : super(key: key);

  Widget _buildPlaceholder(BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: const Center(
          child: Text("Found no recorded months."),
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
          return ListView(
            children: <Widget>[
              const ListHeaderImage(
                semanticLabel: "Monthly Reports",
                subtitle: "Reports",
                image: IMAGES.monthlyReport,
              ),
              // Only display previous months not the current one.
              if (snapshot.data.length <= 1)
                _buildPlaceholder(context),
              if (snapshot.data.isNotEmpty)
                for (var m in snapshot.data.sublist(1))
                  CompactDetailsCard(month: m)
            ],
          );
        } else {
          return _buildPlaceholder(context);
        }
      },
    );
  }
}
