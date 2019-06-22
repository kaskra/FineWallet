/*
 * Developed by Lukas Krauch 22.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

import 'package:finewallet/Blocs/transaction_bloc.dart';
import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/general_widgets.dart';
import 'package:finewallet/resources/internal_data.dart';
import 'package:finewallet/resources/transaction_list.dart';
import 'package:finewallet/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sticky_headers/sticky_headers.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage(this.title, {Key key, @required this.day, this.showAppBar: true})
      : super(key: key);

  final String title;
  final int day;
  final bool showAppBar;

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  TransactionBloc _txBloc = TransactionBloc(dayInMillis(DateTime.now()));
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (widget?.day != null) {
      _txBloc = TransactionBloc(widget.day);
    }
  }

  void _showSnackBar(BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Deleted transaction"),
      duration: Duration(milliseconds: 500),
    ));
  }

  Widget _upperCardPart(
      int iconIndex, String subcategoryName, bool isRecurring) {
    return Stack(
      children: <Widget>[
        Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
                color: Colors.black12,
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(4, 4, 4, 8),
              child: Text(""),
            ),
          ],
        ),
        Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: BorderDirectional(
                  bottom: BorderSide(color: Colors.black54),
                ),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(4, 4, 4, 8),
              margin: EdgeInsets.only(left: 15),
              child: Text(""),
            )
          ],
        ),
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: 15,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Icon(icons[iconIndex]),
            ),
            Expanded(
                child: Container(
              child: Center(
                child: Text(
                  subcategoryName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              padding: EdgeInsets.only(top: 4, bottom: 4),
              margin: EdgeInsets.only(left: 4, right: 4),
            )),
            isRecurring
                ? Icon(
                    Icons.replay,
                    color: Colors.red,
                  )
                : Container()
          ],
        ),
      ],
    );
  }

  Widget _lowerCardPart(double amount, bool isExpense) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      padding: EdgeInsets.only(right: 15, left: 15),
      child: Text(
        "${amount.toStringAsFixed(2)}€",
        maxLines: 1,
        overflow: TextOverflow.fade,
        style: TextStyle(
            color: isExpense ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 14),
        textDirection: isExpense ? TextDirection.rtl : TextDirection.ltr,
      ),
      alignment: isExpense ? Alignment.centerRight : Alignment.centerLeft,
    );
  }

  Widget _transactionCard(TransactionModel item) {
    return Column(
      children: <Widget>[
        _upperCardPart(
            item.category - 1, item.subcategoryName, item.isRecurring.isOdd),
        _lowerCardPart(item.amount, item.isExpense == 1)
      ],
    );
  }

  Widget _separator(bool isToday, String dateString) {
    return Center(
        child: Container(
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black38,
            ),
            child: Text(
              isToday ? "TODAY" : dateString.toUpperCase(),
              style: TextStyle(
                  color: Theme.of(context).textTheme.button.color,
                  fontSize: 11,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal),
            )));
  }

  Future<bool> _showDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete transaction?"),
            content: Text("This will delete the transaction."),
            actions: <Widget>[
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text("Confirm"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        }).then((v) {
      return v;
    });
  }

  Widget _historyItem(TransactionModel item) {
    return Row(
      children: <Widget>[
        (item.isExpense == 1)
            ? Spacer(
                flex: 1,
              )
            : Container(),
        Expanded(
          flex: 3,
          child: Dismissible(
            direction: DismissDirection.endToStart,
            key: Key("Trans_" + item.id.toString()),
            background: Container(
              padding: EdgeInsets.only(right: 25),
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete_outline,
                  color: Theme.of(context).iconTheme.color),
              color: Color(0x88FF0000),
            ),
            onDismissed: (DismissDirection direction) {
              _txBloc.delete(item.id);
              _showSnackBar(context);
            },
            confirmDismiss: (DismissDirection direction) => _showDialog(),
            child: generalCard(_transactionCard(item), null, 3),
          ),
        ),
        (item.isExpense == 0)
            ? Spacer(
                flex: 1,
              )
            : Container(),
      ],
    );
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
        intl.DateFormat d = intl.DateFormat.MMMEd();
        String dateString =
            d.format(DateTime.fromMillisecondsSinceEpoch(prevDate));
        bool isToday = prevDate == dayInMillis(DateTime.now());
        l = List();
        l.add(_separator(isToday, dateString));
      }
      l.add(_historyItem(snapshot.data[i]));
    }
    listOfLists.add(l);
    return listOfLists;
  }

  @override
  Widget build(BuildContext context) {
    _txBloc.update();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffd8e7ff),
      appBar: widget.showAppBar
          ? AppBar(
              iconTheme: Theme.of(context).iconTheme,
              centerTitle: true,
              title: Text(
                widget.title,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            )
          : null,
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: _buildBody(),
      ),
    );
  }
}
