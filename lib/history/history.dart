/*
 * Developed by Lukas Krauch $file.today.day.$file.today.month.$file.today.year.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:finewallet/add_page/add_page.dart';
import 'package:finewallet/general/general_widgets.dart';
import 'package:finewallet/general/selection_appbar.dart';
import 'package:finewallet/history/date_separator.dart';
import 'package:finewallet/history/history_item.dart';
import 'package:finewallet/models/transaction_model.dart';
import 'package:finewallet/resources/blocs/transaction_bloc.dart';
import 'package:finewallet/resources/transaction_list.dart';
import 'package:finewallet/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class History extends StatefulWidget {
  History({this.onChangeSelectionMode});

  final void Function(bool) onChangeSelectionMode;

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  TransactionBloc _txBloc = TransactionBloc(dayInMillis(DateTime.now()));

  Map<int, TransactionModel> _selectedItems = new Map();
  bool _selectionMode = false;

  @override
  Widget build(BuildContext context) {
    _txBloc.update();

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _selectionMode ? customAppBar() : Container(),
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

  Widget customAppBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SelectionAppBar(
        title: "FineWallet",
        selectedItems: _selectedItems,
        onClose: () => closeSelection(),
        onEdit: () => editItem(),
        onDelete: () => deleteItems(),
      ),
    );
  }

  void deleteItems() async {
    if (await showConfirmDialog(
        context, "Delete transaction?", "This will delete the transaction.")) {
      for (TransactionModel tx in _selectedItems.values) {
        _txBloc.delete(tx.id);
      }
      closeSelection();
    }
  }

  void editItem() {
    TransactionModel tx = _selectedItems.values.first;
    int isExpense = 0;
    String title = "Income";

    if (tx.isExpense == 1) {
      isExpense = 1;
      title = "Expense";
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddPage(title, isExpense, transaction: tx)));
    closeSelection();
  }

  void closeSelection() {
    setState(() {
      _selectedItems.clear();
      _selectionMode = false;
    });
    _checkSelectionMode();
  }

  void _checkSelectionMode() async {
    if (widget.onChangeSelectionMode != null) {
      widget.onChangeSelectionMode(_selectionMode);
    }
  }

  Widget _buildBody() {
    return StreamBuilder<TransactionList>(
        stream: _txBloc.transactions,
        builder:
            (BuildContext context, AsyncSnapshot<TransactionList> snapshot) {
          if (snapshot.hasData) {
            List<List<Widget>> listOfLists = _buildLists(snapshot);
            return ListView.builder(
              padding: EdgeInsets.only(bottom: 50),
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
                  return Container();
                }
              },
            );
          } else {
            return Container();
          }
        });
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
      l.add(HistoryItem(
        key: key,
        context: context,
        transaction: snapshot.data[i],
        isSelected: _selectedItems.containsKey(snapshot.data[i].id),
        isSelectionModeActive: _selectionMode,
        onSelect: (selected) {
          if (selected) {
            if (!_selectedItems.containsKey(snapshot.data[i].id)) {
              _selectedItems.putIfAbsent(
                  snapshot.data[i].id, () => snapshot.data[i]);
              _selectionMode = true;
            }
          } else {
            _selectedItems.remove(snapshot.data[i].id);
            if (_selectedItems.isEmpty) {
              _selectionMode = false;
            }
          }
          _checkSelectionMode();
        },
      ));
    }
    listOfLists.add(l);
    return listOfLists;
  }
}
