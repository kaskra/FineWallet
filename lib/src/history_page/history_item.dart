/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:16:55 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/constants.dart';
import 'package:FineWallet/core/datatypes/category_icon.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/src/history_page/history_item_icon.dart';
import 'package:FineWallet/src/widgets/decorated_card.dart';
import 'package:FineWallet/src/widgets/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  HistoryItem(
      {@required Key key,
      @required this.context,
      @required this.transaction,
      @required this.isSelected,
      @required this.isSelectionModeActive,
      this.onSelect})
      : isExpense = transaction.isExpense,
        isRecurring = transaction.isRecurring;
  final BuildContext context;
  final TransactionsWithCategory transaction;
  final bool isExpense;
  final bool isRecurring;
  final bool isSelectionModeActive;
  final void Function(bool) onSelect;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isExpense ? Alignment.centerRight : Alignment.centerLeft,
      child: ExpandToWidth(
        ratio: 0.55,
        height: 60,
        child: DecoratedCard(
          borderRadius: BorderRadius.circular(CARD_RADIUS),
          color: isSelected
              ? Colors.grey.withOpacity(0.6)
              : Theme.of(context).cardTheme.color,
          borderColor: isSelected
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,
          borderWidth: isSelected ? 2 : 0,
          padding: 0,
          child: InkWell(
            child: _buildMainItemContent(context),
            onTap: () {
              bool isSelect = false;
              if (isSelected) {
                isSelect = false;
              } else if (isSelectionModeActive) {
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
          ),
        ),
      ),
    );
  }

  Row _buildMainItemContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: HistoryItemIcon(
            isSelected: isSelected,
            isExpense: isExpense,
            isRecurring: isRecurring,
            iconData: CategoryIcon(transaction.categoryId - 1),
            context: context,
          ),
        ),
        _buildContent(),
      ],
    );
  }

  Widget _buildItemTitle() {
    return Align(
      alignment: Alignment.topLeft,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          transaction.subcategoryName,
          style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(bottom: 8, top: 8, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[_buildItemTitle(), _buildItemText()],
        ),
      ),
    );
  }

  Widget _buildItemText() {
    String prefix = (isExpense && transaction.amount > 0) ? "-" : "";
    String suffix = "€";
    Color color = isExpense ? Colors.red : Colors.green;
    return Align(
      alignment: Alignment.bottomRight,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Text(
          prefix + transaction.amount.toStringAsFixed(2) + suffix,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15, color: color),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
