/*
 * Developed by Lukas Krauch $file.today.day.$file.today.month.$file.today.year.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:FineWallet/add_page/add_page.dart';
import 'package:FineWallet/general/general_widgets.dart';
import 'package:FineWallet/general/selection_appbar.dart';
import 'package:FineWallet/history/date_separator.dart';
import 'package:FineWallet/history/history_item.dart';
import 'package:FineWallet/models/transaction_model.dart';
import 'package:FineWallet/resources/blocs/transaction_bloc.dart';
import 'package:FineWallet/resources/transaction_list.dart';
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
      child: Consumer<TransactionBloc>(
        builder: (_, bloc, child) => SelectionAppBar(
          title: "FineWallet",
          selectedItems: _selectedItems,
          onClose: () => _closeSelection(),
          onEdit: () => _editItem(),
          onDelete: () => _deleteItems(bloc),
        ),
      ),
    );
  }

  void _deleteItems(TransactionBloc bloc) async {
    if (await showConfirmDialog(
        context, "Delete transaction?", "This will delete the transaction.")) {
      for (TransactionModel tx in _selectedItems.values) {
        bloc.delete(tx.id);
      }
      _closeSelection();
    }
  }

  void _editItem() {
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
    _closeSelection();
  }

  void _closeSelection() {
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
      l.add(HistoryItem(
        key: key,
        context: context,
        transaction: snapshot.data[i],
        isSelected: _selectedItems.containsKey(snapshot.data[i].id),
        isSelectionModeActive: _selectionMode,
        onSelect: (selected) {
          _toggleSelectionMode(selected, snapshot.data[i]);
          _checkSelectionMode();
        },
      ));
    }
    listOfLists.add(l);
    return listOfLists;
  }

  void _toggleSelectionMode(bool selected, TransactionModel data) {
    if (selected) {
      if (!_selectedItems.containsKey(data.id)) {
        _selectedItems.putIfAbsent(
            data.id, () => data);
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
