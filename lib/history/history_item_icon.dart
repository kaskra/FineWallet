/*
 * Developed by Lukas Krauch 4.8.2019.
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
        padding: const EdgeInsets.all(5),
        color: Theme.of(context).colorScheme.secondaryVariant,
        child: Icon(
          Icons.check,
          size: 25,
        ),
      ),
    );
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
        padding: const EdgeInsets.all(5),
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
      padding: const EdgeInsets.only(right: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            child: child),
      ),
    );
  }

  Widget recurrenceIndicator() {
    return isRecurring
        ? Positioned(
            left: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
                child: Icon(
                  Icons.replay,
                  size: 14,
                ),
              ),
            ),
          )
        : Container();
  }

  Widget expenseIndicator() {
    return Positioned(
      right: 8,
      top: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        child: Container(
          color: isExpense ? Colors.red : Colors.green,
          child: Icon(
            isExpense ? Icons.remove : Icons.add,
            size: 14,
          ),
        ),
      ),
    );
  }
}
