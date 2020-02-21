import 'package:FineWallet/constants.dart';
import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/src/statistics_page/used_budget_bar.dart';
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
                  UsedBudgetBar(
                    model: month,
                    padding: const EdgeInsets.only(top: 0),
                  ),
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
      padding: const EdgeInsets.only(top: 2, bottom: 10),
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
}
