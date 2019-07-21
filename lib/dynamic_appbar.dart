/*
 * Developed by Lukas Krauch $file.today.day.$file.today.month.$file.today.year.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/color_themes.dart';
import 'package:flutter/material.dart';

class DynamicAppBar extends StatefulWidget implements PreferredSizeWidget {
  DynamicAppBar(
      {Key key,
      @required this.title,
      @required this.selectedItems,
      this.isSelectionMode = false,
      this.onDelete,
      this.onEdit})
      : preferredSize = Size.fromHeight(kToolbarHeight);

  final bool isSelectionMode;
  final Map<int, TransactionModel> selectedItems;
  final String title;
  final void Function() onDelete;
  final void Function() onEdit;

  @override
  final Size preferredSize;

  @override
  _DynamicAppBarState createState() => _DynamicAppBarState();
}

class _DynamicAppBarState extends State<DynamicAppBar> {
  @override
  Widget build(BuildContext context) {
    if (widget.isSelectionMode) {
      return _buildSelectionAppBar(widget.selectedItems);
    }
    return _buildDefaultAppBar();
  }

  Widget _buildDefaultAppBar() => AppBar(
        centerTitle: centerAppBar,
        elevation: appBarElevation,
        backgroundColor:
            Theme.of(context).primaryColor.withOpacity(appBarOpacity),
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      );

  Widget _buildSelectionAppBar(Map<int, TransactionModel> selectedItems) {
    return AppBar(
        backgroundColor:
            Theme.of(context).primaryColor.withOpacity(appBarOpacity),
        elevation: appBarElevation,
        actions: <Widget>[
          _buildEditAction(selectedItems),
          _buildDeleteAction()
        ],
        title: Container(
          margin: EdgeInsets.only(left: 15),
          child: Text(
            selectedItems.length.toString(),
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
        ));
  }

  Widget _buildEditAction(Map<int, TransactionModel> selectedItems) {
    return selectedItems.length == 1
        ? Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                if (widget.onEdit != null) {
                  widget.onEdit();
                }
              },
              child: Icon(
                Icons.edit,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          )
        : Container();
  }

  Widget _buildDeleteAction() {
    return Padding(
      padding: EdgeInsets.only(right: 15),
      child: GestureDetector(
        onTap: () {
          if (widget.onDelete != null) {
            widget.onDelete();
          }
        },
        child: Icon(
          Icons.delete,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
