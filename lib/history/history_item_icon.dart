/*
 * Developed by Lukas Krauch $file.today.day.$file.today.month.$file.today.year.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:FineWallet/resources/category_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryItemIcon extends StatelessWidget {
  HistoryItemIcon(
      {@required this.isSelected,
      @required this.isExpense,
      @required this.isRecurring,
      @required this.iconData,
      @required this.context});

  final bool isSelected;
  final bool isRecurring;
  final bool isExpense;
  final CategoryIcon iconData;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return isSelected ? _buildSelectionIcon() : _buildItemIcon();
  }

  Widget _buildSelectionIcon() {
    return _iconWrapper(
        child: Container(
      padding: EdgeInsets.all(5),
      color: Theme.of(context).colorScheme.secondaryVariant,
      child: Icon(
        Icons.check,
        size: 25,
      ),
    ));
  }

  Widget _buildItemIcon() {
    return Stack(
      children: <Widget>[
        _categoryIcon(),
        expenseIndicator(),
        recurrenceIndicator()
      ],
    );
  }

  Widget _categoryIcon() {
    return _iconWrapper(
      child: Container(
        padding: EdgeInsets.all(5),
        color: Theme.of(context).colorScheme.secondary,
        child: Icon(
          iconData.data,
          size: 25,
        ),
      ),
    );
  }

  Widget _iconWrapper({Widget child}) {
    return Padding(
        padding: EdgeInsets.only(right: 10),
        child: Align(
          alignment: Alignment.topLeft,
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              child: child),
        ));
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
}
