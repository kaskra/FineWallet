/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:17:07 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:FineWallet/core/models/transaction_model.dart';
import 'package:FineWallet/src/add_page/add_page.dart';
import 'package:FineWallet/src/widgets/general_widgets.dart';
import 'package:FineWallet/src/widgets/selection_appbar.dart';
import 'package:FineWallet/src/history_page/date_separator.dart';
import 'package:FineWallet/src/history_page/history_item.dart';
import 'package:FineWallet/core/resources/blocs/transaction_bloc.dart';
import 'package:FineWallet/core/resources/blocs/month_bloc.dart';
import 'package:FineWallet/core/resources/transaction_list.dart';
import 'package:FineWallet/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class History extends StatefulWidget {
  History({this.onChangeSelectionMode});

  @override
  _HistoryState createState() => _HistoryState();

  final void Function(bool) onChangeSelectionMode;
}

class _HistoryState extends State<History> {
  Map<int, TransactionModel> _selectedItems = new Map();
  bool _selectionMode = false;

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
      for (TransactionModel tx in _selectedItems.values) {
        Provider.of<TransactionBloc>(context).delete(tx.id);
        Provider.of<MonthBloc>(context).syncMonths();
      }
      _closeSelection();
    }
  }

  /// Edit an item on the add page. Close selection mode afterwards.
  void _editItem(TransactionModel tx) {
    int isExpense = tx.isExpense;
    String title = tx.isExpense == 1 ? "Expense" : "Income";
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddPage(title, isExpense, transaction: tx)));
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

  Widget _buildBody() {
    return Consumer<TransactionBloc>(
      builder: (_, bloc, child) {
        bloc.updateAllTransactions();
        return StreamBuilder<TransactionList>(
          stream: bloc.allTransactions,
          builder:
              (BuildContext context, AsyncSnapshot<TransactionList> snapshot) {
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
      },
    );
  }

  List<List<Widget>> _buildLists(AsyncSnapshot<TransactionList> snapshot) {
    List<List<Widget>> listOfLists = List();
    List<Widget> l = List();
    int prevDate = -1;
    for (var i = 0; i < snapshot.data.length; i++) {
      if (snapshot.data[i].date != prevDate) {
        prevDate = snapshot.data[i].date;
        listOfLists.add(l);
        bool isToday = prevDate == dayInMillis(DateTime.now());
        l = List();
        l.add(DateSeparator(isToday: isToday, dateInMillis: prevDate));
      }

      var key = new Key(snapshot.data.hashCode.toString());
      l.add(
        HistoryItem(
          key: key,
          context: context,
          transaction: snapshot.data[i],
          isSelected: _selectedItems.containsKey(snapshot.data[i].id),
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

  void _toggleSelectionMode(bool selected, TransactionModel data) {
    if (selected) {
      if (!_selectedItems.containsKey(data.id)) {
        _selectedItems.putIfAbsent(data.id, () => data);
        _selectionMode = true;
      }
    } else {
      _selectedItems.remove(data.id);
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
