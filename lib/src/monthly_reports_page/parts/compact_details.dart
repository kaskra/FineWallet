import 'package:FineWallet/constants.dart';
import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/src/statistics_page/used_budget_bar.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/structure/structure_space.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompactDetailsCard extends StatelessWidget {
  final MonthWithDetails month;

  const CompactDetailsCard({Key key, @required this.month}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: <Widget>[
          DecoratedCard(
            padding: 10,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: Center(
                      child: Text(
                    getMonthName(DateTime.fromMillisecondsSinceEpoch(
                                month.month.firstDate)
                            .month) +
                        ", ${DateTime.fromMillisecondsSinceEpoch(month.month.firstDate).year}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary),
                  )),
                ),
                UsedBudgetBar(
                  padding: const EdgeInsets.only(
                      top: 0, left: 10, right: 10, bottom: 5),
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
    var value = month.income - month.expense;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 14),
          child: Column(
            children: <Widget>[
              Text(
                "${value > 0 ? "+" : ""}${value.toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).currency}",
                style: TextStyle(
                    color: value > 0 ? Colors.green : Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "Saved Amount",
                style: TextStyle(
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
            borderRadius: BorderRadius.circular(CARD_RADIUS)),
        onPressed: () {
          print("Navigate!");
        },
        elevation: 4,
        height: 30,
        child: Text(
          "Show Details",
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w600),
        ),
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
