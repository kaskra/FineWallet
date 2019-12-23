/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:17:07 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/data/filters/filter_settings.dart';
import 'package:FineWallet/data/moor_database.dart';
import 'package:FineWallet/data/transaction_dao.dart';
import 'package:FineWallet/src/add_page-rework/add_page_rework.dart';
import 'package:FineWallet/src/history_page/date_separator.dart';
import 'package:FineWallet/src/history_page/history_item.dart';
import 'package:FineWallet/src/widgets/general_widgets.dart';
import 'package:FineWallet/src/widgets/selection_appbar.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class History extends StatefulWidget {
  History({
    this.onChangeSelectionMode,
    this.selectedItems,
  });

  @override
  _HistoryState createState() => _HistoryState();

  final void Function(bool) onChangeSelectionMode;
  final List<TransactionsWithCategory> selectedItems;
}

class _HistoryState extends State<History> {
  Map<int, TransactionsWithCategory> _selectedItems = new Map();
  bool _selectionMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedItems != null) {
      if (widget.selectedItems.length > 0) {
        widget.selectedItems.forEach(
            (item) => _selectedItems.putIfAbsent(item.originalId, () => item));
        _selectionMode = true;
        _checkSelectionMode();
      }
    }
  }

  Widget _customAppBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SelectionAppBar(
        title: "FineWallet",
        selectedItems: _selectedItems,
        onClose: () => _closeSelection(),
        onEdit: () => _editItem(_selectedItems.values.first),
        onDelete: () => _deleteItems(),
      ),
    );
  }

  /// Delete the selected items from database. Close selection mode afterwards.
  void _deleteItems() async {
    if (await showConfirmDialog(
        context, "Delete transaction?", "This will delete the transaction.")) {
      for (TransactionsWithCategory tx in _selectedItems.values) {
        Provider.of<AppDatabase>(context)
            .transactionDao
            .deleteTransactionById(tx.originalId);
      }
      _closeSelection();
    }
  }

  /// Edit an item on the add page. Close selection mode afterwards.
  void _editItem(TransactionsWithCategory tx) {
    int isExpense = tx.isExpense ? 1 : 0;
    String title = tx.isExpense ? "Expense" : "Income";
//    Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => AddPage(title, isExpense, transaction: tx)));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddPageRework(
                  isExpense: tx.isExpense,
                  transaction: tx,
                )));
    _closeSelection();
  }

  /// Closes selection mode and clears the selected items list.
  void _closeSelection() {
    setState(() {
      _selectedItems.clear();
      _selectionMode = false;
    });
    _checkSelectionMode();
  }

  /// Execute the passed function when the selection mode changes.
  ///
  /// The selection mode gets activated when some history item is pressed for a longer time.
  /// In selection mode the displayed app bar changes to the selection app bar.
  void _checkSelectionMode() async {
    if (widget.onChangeSelectionMode != null) {
      widget.onChangeSelectionMode(_selectionMode);
    }
  }

  // TODO rework header and sub-lists etc.
  Widget _buildBody() {
    return StreamBuilder<List<TransactionsWithCategory>>(
      stream: Provider.of<AppDatabase>(context)
          .transactionDao
          .watchTransactionsWithFilter(
              TransactionFilterSettings.beforeDate(DateTime.now())),
      builder: (BuildContext context,
          AsyncSnapshot<List<TransactionsWithCategory>> snapshot) {
        if (snapshot.hasData) {
          List<List<Widget>> listOfLists = _buildLists(snapshot);
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 50),
            itemCount: listOfLists.length,
            itemBuilder: (context, index) {
              if (listOfLists[index].length > 0) {
                return StickyHeader(
                  header: listOfLists[index][0],
                  content: Column(
                    children: listOfLists[index]
                        .getRange(1, listOfLists[index].length)
                        .toList(),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  List<List<Widget>> _buildLists(
      AsyncSnapshot<List<TransactionsWithCategory>> snapshot) {
    List<List<Widget>> listOfLists = List();
    List<Widget> l = List();
    int prevDate = -1;
    for (var i = 0; i < snapshot.data.length; i++) {
      if (snapshot.data[i].date != prevDate) {
        prevDate = snapshot.data[i].date;
        listOfLists.add(l);
        bool isToday = prevDate == dayInMillis(DateTime.now());
        l = List();
        l.add(
          DateSeparator(isToday: isToday, dateInMillis: prevDate),
        );
      }

      var key = new Key(snapshot.data.hashCode.toString());
      l.add(
        HistoryItem(
          key: key,
          context: context,
          transaction: snapshot.data[i],
          isSelected: _selectedItems.containsKey(snapshot.data[i].originalId),
          isSelectionModeActive: _selectionMode,
          onSelect: (selected) {
            _toggleSelectionMode(selected, snapshot.data[i]);
            _checkSelectionMode();
          },
        ),
      );
    }
    listOfLists.add(l);
    return listOfLists;
  }

  void _toggleSelectionMode(bool selected, TransactionsWithCategory data) {
    if (selected) {
      if (!_selectedItems.containsKey(data.originalId)) {
        _selectedItems.putIfAbsent(data.originalId, () => data);
        _selectionMode = true;
      }
    } else {
      _selectedItems.remove(data.originalId);
      if (_selectedItems.isEmpty) {
        _selectionMode = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _selectionMode ? _customAppBar() : Container(),
        Expanded(
          child: Container(
            child: MediaQuery.removePadding(
              context: context,
              child: _buildBody(),
              removeTop: true,
            ),
          ),
        )
      ],
    );
  }
}
