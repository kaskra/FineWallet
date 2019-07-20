/*
 * Developed by Lukas Krauch 20.7.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:finewallet/general_widgets.dart';
import 'package:finewallet/resources/blocs/transaction_bloc.dart';
import 'package:finewallet/resources/internal_data.dart';
import 'package:finewallet/resources/transaction_list.dart';
import 'package:finewallet/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ReworkedHistory extends StatefulWidget {
  @override
  _ReworkedHistoryState createState() => _ReworkedHistoryState();
}

class _ReworkedHistoryState extends State<ReworkedHistory> {
  TransactionBloc _txBloc = TransactionBloc(dayInMillis(DateTime.now()));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child:
//            FutureBuilder(
//      future: TransactionsProvider.db.getAllTrans(dayInMillis(DateTime.now())),
//      builder: (context, AsyncSnapshot<TransactionList> snapshot) {
//        if (snapshot.hasData) {
//          List<Widget> items = <Widget>[];
//          for (TransactionModel tx in snapshot.data) {
//            items.add(HistoryItem(
//              amount: tx.amount,
//              isExpense: tx.isExpense == 1,
//              category: tx.category,
//              subcategoryName: tx.subcategoryName,
//              isLast: tx == snapshot.data.last,
//            ));
//          }
//
//          return ListView(
//            children: items,
//          );
//        }
//        return CircularProgressIndicator();
//      },
//    )
                _buildBody()));
  }

  Widget _buildBody() {
    return StreamBuilder<TransactionList>(
        stream: _txBloc.transactions,
        builder:
            (BuildContext context, AsyncSnapshot<TransactionList> snapshot) {
          if (snapshot.hasData) {
            List<List<Widget>> listOfLists = _buildLists(snapshot);
            return ListView.builder(
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
      l.add(HistoryItem(
        amount: snapshot.data[i].amount,
        isExpense: snapshot.data[i].isExpense == 1,
        category: snapshot.data[i].category,
        subcategoryName: snapshot.data[i].subcategoryName,
      ));
    }
    listOfLists.add(l);
    return listOfLists;
  }
}

class HistoryItem extends StatelessWidget {
  HistoryItem(
      {@required this.amount,
      @required this.isExpense,
      @required this.category,
      @required this.subcategoryName});
  final int category;
  final String subcategoryName;
  final double amount;
  final bool isExpense;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: isExpense ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white),
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
                  color: Colors.orange,
                  child: Icon(
                    icons[category - 1],
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
            subcategoryName,
            style: TextStyle(fontSize: 16),
          ),
        ));
  }

  // TODO title bold, icon turns --- when selected

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
    String prefix = isExpense ? "-" : "";
    String suffix = "€";
    Color color = isExpense ? Colors.red : Colors.green;
    return Align(
      alignment: Alignment.bottomRight,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          prefix + amount.toStringAsFixed(2) + suffix,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: color),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
