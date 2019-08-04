/*
 * Developed by Lukas Krauch $file.today.day.$file.today.month.$file.today.year.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:finewallet/models/transaction_model.dart';
import 'package:finewallet/resources/internal_data.dart';
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
                _buildItemIcon(),
                _buildItemContent(),
              ],
            )));
  }

  Widget _buildItemIcon() {
    return Stack(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: Container(
                  padding: EdgeInsets.all(5),
                  color: Theme.of(context).colorScheme.secondary,
                  child: Icon(
                    icons[transaction.category - 1],
                    size: 25,
                  ),
                ),
              ),
            )),
        expenseIndicator(),
        recurrenceIndicator()
      ],
    );
  }

  Widget recurrenceIndicator() {
    return isRecurring
        ? Positioned(
            left: 0,
            bottom: 18,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
                child: Icon(
                  Icons.replay,
                  size: 14,
                ),
              ),
            ))
        : Container();
  }

  Positioned expenseIndicator() {
    return Positioned(
        right: 8,
        top: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          child: Container(
            color: isExpense ? Colors.red : Colors.green,
            child: Icon(
              isExpense ? Icons.remove : Icons.add,
              size: 14,
            ),
          ),
        ));
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
