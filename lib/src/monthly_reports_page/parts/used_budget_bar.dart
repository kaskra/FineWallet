import 'package:FineWallet/constants.dart';
import 'package:FineWallet/data/month_dao.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:provider/provider.dart';

/// This class creates a widget that displays how much money
/// was spend in one month.
class UsedBudgetBar extends StatelessWidget {
  const UsedBudgetBar({
    Key key,
    @required this.model,
    this.padding,
  }) : super(key: key);

  final MonthWithDetails model;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    double firstPart = 0;
    if (model.month.maxBudget != 0) {
      firstPart = model.expense / model.month.maxBudget * 100;
    }

    final backgroundColor = model.expense > 0 && model.month.maxBudget == 0
        ? Colors.redAccent
        : Colors.black.withOpacity(0.05);
    final progressColor = model.expense > model.month.maxBudget
        ? Colors.redAccent
        : Theme.of(context).colorScheme.secondary;

    return Padding(
      padding: padding ??
          const EdgeInsets.fromLTRB(
            10.0,
            15.0,
            10.0,
            0.0,
          ),
      child: Column(
        children: <Widget>[
          RoundedProgressBar(
            style: RoundedProgressBarStyle(
              borderWidth: 0,
              widthShadow: 0,
              colorProgress: progressColor,
              colorProgressDark: progressColor,
              backgroundProgress: backgroundColor,
            ),
            percent: firstPart,
            height: 25,
            childCenter: Text(
              "${model.expense.toStringAsFixed(2)} / ${model.month.maxBudget.toStringAsFixed(2)} ${Provider.of<LocalizationNotifier>(context).userCurrency}",
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            borderRadius: BorderRadius.circular(cardRadius),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              "Used budget",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
