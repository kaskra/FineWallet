/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:16:24 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/constants.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:flutter/material.dart';

// TODO transform to generic
class SelectionAppBar extends StatefulWidget implements PreferredSizeWidget {
  SelectionAppBar(
      {Key key,
      @required this.title,
      this.selectedItems,
      this.onDelete,
      this.onClose,
      this.onEdit})
      : preferredSize = Size.fromHeight(kToolbarHeight);

  final Map<int, TransactionsWithCategory> selectedItems;
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
  Widget _buildSelectionAppBar(
      Map<int, TransactionsWithCategory> selectedItems) {
    return AppBar(
        backgroundColor:
            Theme.of(context).primaryColor.withOpacity(APPBAR_OPACITY),
        elevation: APPBAR_ELEVATION,
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
      padding: const EdgeInsets.only(left: 15),
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

  Widget _buildEditAction(Map<int, TransactionsWithCategory> selectedItems) {
    return selectedItems.length == 1
        ? Padding(
            padding: const EdgeInsets.only(right: 20),
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
      padding: const EdgeInsets.only(right: 15),
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
