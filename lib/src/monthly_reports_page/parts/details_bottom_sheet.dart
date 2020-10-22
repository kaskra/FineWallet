import 'package:FineWallet/constants.dart';
import 'package:FineWallet/data/extensions/datetime_extension.dart';
import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/src/monthly_reports_page/parts/category_view.dart';
import 'package:FineWallet/src/monthly_reports_page/parts/overall_section.dart';
import 'package:FineWallet/src/profile_page/parts/profile_chart.dart';
import 'package:FineWallet/src/widgets/structure/structure_divider.dart';
import 'package:FineWallet/src/widgets/structure/structure_space.dart';
import 'package:FineWallet/src/widgets/structure/structure_title.dart';
import 'package:flutter/material.dart';

class DetailsBottomSheet extends StatelessWidget {
  final MonthWithDetails month;

  const DetailsBottomSheet({Key key, @required this.month}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      enableDrag: false,
      builder: (context) {
        return Column(
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
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Positioned(
          top: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            width: 50,
            height: 4,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            "${month.month.firstDate.getMonthName()} "
            ", ${month.month.firstDate.year}",
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
        const StructureTitle(
          text: "Expenses per Category",
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
