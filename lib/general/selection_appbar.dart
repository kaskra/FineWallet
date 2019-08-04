/*
 * Developed by Lukas Krauch $file.today.day.$file.today.month.$file.today.year.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:finewallet/color_themes.dart';
import 'package:finewallet/models/transaction_model.dart';
import 'package:flutter/material.dart';

class SelectionAppBar extends StatefulWidget implements PreferredSizeWidget {
  SelectionAppBar(
      {Key key,
      @required this.title,
      this.selectedItems,
      this.onDelete,
      this.onClose,
      this.onEdit})
      : preferredSize = Size.fromHeight(kToolbarHeight);

  final Map<int, TransactionModel> selectedItems;
  final String title;
  final void Function() onDelete;
  final void Function() onEdit;
  final void Function() onClose;

  @override
  final Size preferredSize;

  @override
  _SelectionAppBarState createState() => _SelectionAppBarState();
}

class _SelectionAppBarState extends State<SelectionAppBar> {
  @override
  Widget build(BuildContext context) {
    return _buildSelectionAppBar(widget.selectedItems);
  }

  /// Build selection app bar that counts the items in [selectedItems].
  /// Has possible actions like Edit, Delete, Close.
  ///
  /// Returns: The built app bar.
  Widget _buildSelectionAppBar(Map<int, TransactionModel> selectedItems) {
    return AppBar(
        backgroundColor:
            Theme.of(context).primaryColor.withOpacity(appBarOpacity),
        elevation: appBarElevation,
        actions: <Widget>[
          _buildEditAction(selectedItems),
          _buildDeleteAction()
        ],
        leading: _buildCloseAction(),
        titleSpacing: 2,
        title: Text(
          selectedItems.length.toString(),
          maxLines: 1,
          style: TextStyle(
              fontSize: 20, color: Theme.of(context).colorScheme.onSecondary),
        ));
  }

  Widget _buildCloseAction() {
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: GestureDetector(
        onTap: () {
          if (widget.onClose != null) {
            widget.onClose();
          }
        },
        child: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
      ),
    );
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
