import 'dart:math';

import 'package:finewallet/Blocs/transaction_bloc.dart';
import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/Resources/internal_data.dart';
import 'package:finewallet/general_widgets.dart';
import 'package:finewallet/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sticky_headers/sticky_headers.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage(this.title, {Key key}) : super(key: key);

  final String title;

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _txBloc = TransactionBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showSnackbar(BuildContext context) {
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
              foregroundColor: Colors.white,
              backgroundColor: Colors.orange,
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
            item.category - 1, item.subcategoryName, false),
        // TODO revisit when recurring transactions are implemented: false => isRecurring
        _lowerCardPart(item.amount, item.isExpense == 1)
      ],
    );
  }

  Widget _seperator(bool isToday, String dateString) {
    return Center(
        child: Container(
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0x22000000),
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Text(
              isToday ? "TODAY" : dateString,
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal),
            )));
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
              child: Icon(Icons.delete_outline, color: Colors.white),
              color: Color(0x88FF0000),
            ),
            onDismissed: (DismissDirection direction) {
              _txBloc.delete(item.id);
              _showSnackbar(context);
            },
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
    return StreamBuilder<List<TransactionModel>>(
        stream: _txBloc.transactions,
        builder: (BuildContext context,
            AsyncSnapshot<List<TransactionModel>> snapshot) {
          if (snapshot.hasData) {
            List<List<Widget>> listofLists = _buildLists(snapshot);
            return ListView.builder(
              itemCount: listofLists.length,
              itemBuilder: (context, index) {
                if (listofLists[index].length > 0) {
                  return StickyHeader(
                    header: listofLists[index][0],
                    content: Column(
                      children: listofLists[index]
                          .getRange(1, listofLists[index].length)
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

  List<List<Widget>> _buildLists(
      AsyncSnapshot<List<TransactionModel>> snapshot) {
    List<List<Widget>> listofLists = List();
    List<Widget> l = List();
    int prevDate = -1;
    for (var i = 0; i < snapshot.data.length; i++) {
      if (snapshot.data[i].date != prevDate) {
        prevDate = snapshot.data[i].date;
        listofLists.add(l);
        intl.DateFormat d = intl.DateFormat.MMMEd();
        String dateString =
            d.format(DateTime.fromMillisecondsSinceEpoch(prevDate));
        bool isToday = prevDate == dayInMillis(DateTime.now());
        l = List();
        l.add(_seperator(isToday, dateString));
      }
      l.add(_historyItem(snapshot.data[i]));
    }
    listofLists.add(l);
    return listofLists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffd8e7ff),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: _buildBody(),
      ),
      // TODO remove FAB when done
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          TransactionModel tx = new TransactionModel(
              subcategory: Random.secure().nextInt(60) + 1,
              amount: Random().nextDouble() * 100,
              date: dayInMillis(
                  DateTime.now().add(Duration(days: -Random().nextInt(3)))),
              isExpense: 1);
          _txBloc.add(tx);
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
