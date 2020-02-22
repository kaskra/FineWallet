import 'package:FineWallet/constants.dart';
import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/src/monthly_reports_page/parts/category_view.dart';
import 'package:FineWallet/src/monthly_reports_page/parts/overall_section.dart';
import 'package:FineWallet/src/profile_page/parts/profile_chart.dart';
import 'package:FineWallet/src/widgets/structure/structure_divider.dart';
import 'package:FineWallet/src/widgets/structure/structure_space.dart';
import 'package:FineWallet/src/widgets/structure/structure_title.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';

class DetailsBottomSheet extends StatelessWidget {
  final MonthWithDetails month;

  const DetailsBottomSheet({Key key, @required this.month}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {
        print("is_closing!");
      },
      enableDrag: false,
      builder: (context) {
        return SizedBox(
          height: 350,
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Column(
                children: <Widget>[
                  _buildTitle(context),
                  StructureDivider(),
                  OverallDetail(month: month),
                  StructureSpace(),
                  _buildCategoryChart(),
                  _buildCategoryList(context)
                ],
              ),
            ),
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CARD_RADIUS),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: Text(
        getMonthName(DateTime.fromMillisecondsSinceEpoch(month.month.firstDate)
                .month) +
            ", ${DateTime.fromMillisecondsSinceEpoch(month.month.firstDate).year}",
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }

  Widget _buildCategoryChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StructureTitle(
          text: "Categories",
        ),
        SizedBox(
          height: 170,
          child: ProfileChart(
            type: ProfileChart.MONTHLY_CHART,
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
