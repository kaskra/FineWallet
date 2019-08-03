/*
 * Developed by Lukas Krauch 20.7.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/dynamic_appbar.dart';
import 'package:finewallet/general_widgets.dart';
import 'package:finewallet/resources/blocs/transaction_bloc.dart';
import 'package:finewallet/resources/internal_data.dart';
import 'package:finewallet/resources/transaction_list.dart';
import 'package:finewallet/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ReworkedHistory extends StatefulWidget {
  ReworkedHistory({this.onChangeSelectionMode});

  final void Function(bool) onChangeSelectionMode;

  @override
  _ReworkedHistoryState createState() => _ReworkedHistoryState();
}

class _ReworkedHistoryState extends State<ReworkedHistory> {
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
      child: DynamicAppBar(
        title: "FineWallet",
        isSelectionMode: _selectionMode,
        selectedItems: _selectedItems,
        onClose: () => closeSelection(),
        onEdit: () => editItem(),
        onDelete: () => deleteItems(),
      ),
    );
  }

  void deleteItems() async {
    print("Delete");
    if (await showConfirmDialog(
        context, "Delete transaction?", "This will delete the transaction.")) {
      for (TransactionModel tx in _selectedItems.values) {
        _txBloc.delete(tx.id);
      }
      closeSelection();
    }
  }

  void editItem() {
    print("Edit");
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

class HistoryItem extends StatelessWidget {
  HistoryItem(
      {@required Key key,
      @required this.context,
      @required this.transaction,
      @required this.isSelected,
      @required this.isSelectionModeActive,
      this.onSelect})
      : isExpense = transaction.isExpense == 1,
        isRecurring = transaction.isRecurring == 1;
  final BuildContext context;
  final TransactionModel transaction;
  final bool isExpense;
  final bool isRecurring;
  final bool isSelectionModeActive;
  final void Function(bool) onSelect;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (onSelect != null) {
          onSelect(true);
        }
      },
      onTap: () {
        bool isSelect = false;
        if (isSelected) {
          isSelect = false;
        } else if (isSelectionModeActive) {
          isSelect = true;
        }
        if (onSelect != null) {
          onSelect(isSelect);
        }
      },
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Align(
        alignment: isExpense ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: isSelected
                    ? Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2)
                    : null,
                color:
                    isSelected ? Colors.grey.withOpacity(0.6) : Colors.white),
            padding: EdgeInsets.only(left: 10, right: 10, top: 15),
            margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
            height: 70,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildItemIcon(),
                _buildItemContent(),
              ],
            )));
  }

  Widget _buildItemIcon() {
    return Stack(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: Container(
                  padding: EdgeInsets.all(5),
                  color: Theme.of(context).colorScheme.secondary,
                  child: Icon(
                    icons[transaction.category - 1],
                    size: 25,
                  ),
                ),
              ),
            )),
        Positioned(
            right: 8,
            top: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              child: Container(
                color: isExpense ? Colors.red : Colors.green,
                child: Icon(
                  isExpense ? Icons.remove : Icons.add,
                  size: 14,
                ),
              ),
            ))
      ],
    );
  }

  Widget _buildItemTitle() {
    return Align(
        alignment: Alignment.topLeft,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            transaction.subcategoryName,
            style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
          ),
        ));
  }

  // TODO add repeating symbol

  Widget _buildItemContent() {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_buildItemTitle(), _buildItemText()],
      ),
    ));
  }

  Widget _buildItemText() {
    String prefix = isExpense && transaction.amount < 0 ? "-" : "";
    String suffix = "€";
    Color color = isExpense ? Colors.red : Colors.green;
    return Align(
      alignment: Alignment.bottomRight,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          prefix + transaction.amount.toStringAsFixed(2) + suffix,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: color),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
