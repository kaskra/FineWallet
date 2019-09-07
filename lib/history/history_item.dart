/*
 * Developed by Lukas Krauch $file.today.day.$file.today.month.$file.today.year.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:FineWallet/history/history_item_icon.dart';
import 'package:FineWallet/models/transaction_model.dart';
import 'package:FineWallet/resources/category_icon.dart';
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
      : isExpense = transaction.isExpense == 1,
        isRecurring = transaction.isRecurring == 1;
  final BuildContext context;
  final TransactionModel transaction;
  final bool isExpense;
  final bool isRecurring;
  final bool isSelectionModeActive;
  final void Function(bool) onSelect;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (onSelect != null) {
          onSelect(true);
        }
      },
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
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Align(
        alignment: isExpense ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: isSelected
                    ? Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2)
                    : null,
                color:
                    isSelected ? Colors.grey.withOpacity(0.6) : Colors.white),
            padding: EdgeInsets.only(left: 10, right: 10, top: 15),
            margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
            height: 70,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                HistoryItemIcon(
                  isSelected: isSelected,
                  isExpense: isExpense,
                  isRecurring: isRecurring,
                  iconData: CategoryIcon(transaction.category - 1),
                  context: context,
                ),
                _buildItemContent(),
              ],
            )));
  }

  Widget _buildItemTitle() {
    return Align(
        alignment: Alignment.topLeft,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            transaction.subcategoryName,
            style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
          ),
        ));
  }

  Widget _buildItemContent() {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_buildItemTitle(), _buildItemText()],
      ),
    ));
  }

  Widget _buildItemText() {
    String prefix = isExpense && transaction.amount < 0 ? "-" : "";
    String suffix = "€";
    Color color = isExpense ? Colors.red : Colors.green;
    return Align(
      alignment: Alignment.bottomRight,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          prefix + transaction.amount.toStringAsFixed(2) + suffix,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: color),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
