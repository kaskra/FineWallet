import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/resources/asset_dictionary.dart';
import 'package:FineWallet/src/monthly_reports_page/parts/compact_details.dart';
import 'package:FineWallet/src/widgets/standalone/list_header_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyReportsPage extends StatelessWidget {
  const MonthlyReportsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MonthWithDetails>>(
      stream: Provider.of<AppDatabase>(context)
          .monthDao
          .watchAllMonthsWithDetails(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        return snapshot.hasData
            ? ListView(
                children: <Widget>[
                  ListHeaderImage(
                    semanticLabel: "Monthly Reports",
                    subtitle: "Reports",
                    image: Images.MONTHLY_REPORT,
                  ),
                  // Only display previous months not the current one.
                  for (var m in snapshot.data.sublist(1))
                    CompactDetailsCard(month: m)
                ],
              )
            : const Center(
                child: Text("Found no recorded months!"),
              );
      },
    );
  }
}
