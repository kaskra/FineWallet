import 'package:FineWallet/core/datatypes/category_icon.dart';
import 'package:FineWallet/data/providers/localization_notifier.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/src/widgets/indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryItem extends StatelessWidget {
  HistoryItem(
      {Key key,
      @required this.transaction,
      @required this.onSelect,
      @required this.isSelected,
      @required this.isSelectionActive})
      : super(key: key);

  final TransactionsWithCategory transaction;
  final Function(bool) onSelect;
  final bool isSelected;
  final bool isSelectionActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: CustomPaint(
        foregroundPainter: IndicatorPainter(
          color: transaction.isExpense ? Colors.red : Colors.green,
          thickness: 6,
          side:
              transaction.isExpense ? IndicatorSide.RIGHT : IndicatorSide.LEFT,
        ),
        child: Material(
          color: isSelected ? Color(0xFF6F6F6F) : null,
          elevation: Theme.of(context).cardTheme.elevation,
          child: ListTile(
            onTap: () {
              bool isSelect = false;
              if (isSelected) {
                isSelect = false;
              } else if (isSelectionActive) {
                isSelect = true;
              }
              if (onSelect != null) {
                onSelect(isSelect);
              }
            },
            onLongPress: () {
              if (onSelect != null) {
                onSelect(true);
              }
            },
            title: Text(
              transaction.subcategoryName,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : null),
            ),
            subtitle: Text(
              transaction.subcategoryName,
              style: TextStyle(color: isSelected ? Colors.white : null),
            ),
            trailing: _buildAmountText(context),
            leading: _buildItemIcon(context),
          ),
        ),
      ),
    );
  }

  Widget _buildItemIcon(BuildContext context) {
    return CircleAvatar(
      child: Icon(
        isSelected
            ? Icons.check
            : CategoryIcon(transaction.categoryId - 1).data,
        color: Theme.of(context).iconTheme.color,
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );
  }

  Widget _buildAmountText(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        transaction.isRecurring
            ? Icon(
                Icons.replay,
                color: Theme.of(context).colorScheme.secondary,
                size: 18,
              )
            : SizedBox(),
        Text(
          " ${transaction.isExpense ? "-" : ""}${transaction.amount.toStringAsFixed(2)}${Provider.of<LocalizationNotifier>(context).currency}",
          style: TextStyle(
              fontSize: 16,
              color: isSelected
                  ? Colors.white
                  : (transaction.isExpense ? Colors.red : Colors.green),
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
