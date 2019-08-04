/*
 * Developed by Lukas Krauch $file.today.day.$file.today.month.$file.today.year.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:flutter/material.dart';

class HistoryItemIcon extends StatefulWidget {
  HistoryItemIcon(
      {@required this.isSelected,
      @required this.isExpense,
      @required this.isRecurring,
      @required this.iconData});

  final bool isSelected;
  final bool isRecurring;
  final bool isExpense;
  final IconData iconData;

  @override
  _HistoryItemIconState createState() => _HistoryItemIconState();
}

class _HistoryItemIconState extends State<HistoryItemIcon> {
  Widget _selectionWidget = Container(
    width: 40,
    height: 40,
    color: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    return _buildItemIcon();
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
    return Padding(
        padding: EdgeInsets.only(right: 10),
        child: Align(
          alignment: Alignment.topLeft,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            child: Container(
              padding: EdgeInsets.all(5),
              color: Theme.of(context).colorScheme.secondary,
              child: Icon(
                widget.iconData,
                size: 25,
              ),
            ),
          ),
        ));
  }

  Widget recurrenceIndicator() {
    return widget.isRecurring
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
            color: widget.isExpense ? Colors.red : Colors.green,
            child: Icon(
              widget.isExpense ? Icons.remove : Icons.add,
              size: 14,
            ),
          ),
        ));
  }
}
