/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:16:49 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/datatypes/category_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconWrapper extends StatelessWidget {
  const IconWrapper({
    Key key,
    @required this.child,
    this.alignment = Alignment.topLeft,
    this.padding = const EdgeInsets.only(right: 10),
    this.clipRadius = 25,
  }) : super(key: key);

  final Widget child;
  final Alignment alignment;
  final EdgeInsetsGeometry padding;
  final double clipRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Align(
        alignment: alignment,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(clipRadius)),
          child: child,
        ),
      ),
    );
  }
}

class SelectionIcon extends StatelessWidget {
  const SelectionIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconWrapper(
      child: Container(
        padding: const EdgeInsets.all(5),
        color: Theme.of(context).colorScheme.secondary,
        child: Icon(
          Icons.check,
          size: 25,
        ),
      ),
    );
  }
}

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
    return isSelected ? SelectionIcon() : _buildItemIcon();
  }

  Widget _buildItemIcon() {
    return Stack(
      children: <Widget>[
        _buildCategoryIcon(),
        _buildExpenseIndicator(),
        _buildRecurrenceIndicator()
      ],
    );
  }

  Widget _buildCategoryIcon() {
    return IconWrapper(
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

  Widget _buildRecurrenceIndicator() {
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

  Widget _buildExpenseIndicator() {
    return Positioned(
      right: 4,
      top: -2,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                Border.all(color: Theme.of(context).cardTheme.color, width: 2),
            color: isExpense ? Colors.red : Colors.green,
          ),
          child: Icon(
            isExpense ? Icons.remove : Icons.add,
            size: 14,
          ),
        ),
      ),
    );
  }
}
